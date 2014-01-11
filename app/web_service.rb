class WebService < Sinatra::Base
  class MethodOverrideHack
    def initialize(app)
      @app = app
    end

    def call(env)
      req = Rack::Request.new env
      override = req.params['_method']

      env['REQUEST_METHOD'] = override.upcase if override

      @app.call env
    end
  end

  use MethodOverrideHack

  use Chassis::Rack::Ping
  use Chassis::Rack::Bouncer
  use Rack::BounceFavicon

  use Chassis::Rack::Instrumentation
  use Manifold::Middleware
  use Rack::Deflater

  use Rack::PostBodyContentTypeParser

  class ParameterMissingError < StandardError
    def initialize(key)
      @key = key
    end

    def to_s
      %Q{Request did not provide "#{@key}"}
    end
  end

  class AuthHeaderMissingError < StandardError
    def to_s
      "X-Token header missing"
    end
  end

  configure :production, :staging do
    enable :logging
  end

  helpers do
    def extract!(key)
      value = params.fetch(key.to_s) do
        raise ParameterMissingError, key
      end

      raise ParameterMissingError, key unless value.is_a?(Hash)

      value
    end

    def current_user
      token = env.fetch 'HTTP_X_TOKEN' do
        raise AuthHeaderMissingError
      end

      UserRepo.find_by_token! token
    end

    def halt_json_error(code, errors = {})
      json_error env.fetch('sinatra.error'), code, errors
    end

    def json_error(ex, code, errors = {})
      halt code, { 'Content-Type' => 'application/json' }, JSON.dump({
        message: ex.message
      }.merge(errors))
    end

    def serialize(object, options = {})
      klass = options[:serializer] || object.active_model_serializer
      options[:scope] ||= nil
      serializer = klass.new(object, options)
      serializer.as_json
    end
  end

  error ParameterMissingError do
    halt_json_error 400
  end

  error UserRepo::UnknownTokenError do
    halt_json_error 403
  end

  error Chassis::Repo::RecordNotFoundError do
    halt_json_error 404
  end

  error PermissionDeniedError do
    halt_json_error 403
  end

  error AuthHeaderMissingError do
    halt_json_error 412
  end

  error ValidationError do
    halt_json_error 422, errors: env['sinatra.error'].as_json
  end

  post '/user_token' do
    form = UserTokenForm.new extract!(:user_token)
    use_case = SendUserToken.new form
    use_case.run!

    status 202
  end

  post '/users' do
    begin
      form = CreateUserForm.new extract!(:user)
      use_case = CreateUser.new form

      user = use_case.run!

      status 201
      json serialize(user, scope: user)
    rescue CreateUser::UnknownAuthCodeError => ex
      json_error ex, 403
    end
  end

  post '/backstage/users' do
    auth_token = AuthToken.create do |auth|
      auth.code = SecureRandom.uuid
      auth.phone_number = '+12348329848'
    end

    form = CreateUserForm.new extract!(:user)
    form.device = {
      'uuid' => SecureRandom.uuid,
      'push_token' => nil
    }
    form.auth_token = auth_token.code

    use_case = CreateUser.new form
    user = use_case.run!

    status 201
    json serialize(user, scope: user)
  end

  put '/device' do
    form = DeviceForm.new extract!(:device)
    use_case = UpdateDevice.new form, current_user

    device = use_case.run!

    status 200
    json serialize(device)
  end

  get '/self' do
    json serialize(current_user)
  end

  post '/groups' do
    form = GroupForm.new extract!(:group)
    use_case = CreateGroup.new form, current_user

    group = use_case.run!

    status 201
    json serialize(group)
  end

  put '/groups/:group_id' do |group_id|
    form = GroupForm.new extract!(:group)
    use_case = UpdateGroup.new group_id, form, current_user

    group = use_case.run!

    status 200
    json serialize(group)
  end

  get '/groups' do
    form = GroupsQueryForm.from_params params
    use_case = QueryGroups.new form, current_user

    status 200
    json serialize(use_case.results, root: :groups)
  end

  get '/groups/:id' do |group_id|
    use_case = FindGroup.new group_id, current_user

    status 200
    json serialize(use_case.group)
  end

  delete '/groups/:group_id' do |group_id|
    use_case = DeleteGroup.new group_id, current_user
    use_case.run!

    nil
  end

  post '/groups/:group_id/pictures' do |group_id|
    form = PictureForm.new extract!(:picture)
    use_case = AddPicture.new group_id, form, current_user

    picture = use_case.run!

    status 201
    json serialize(picture)
  end

  post '/backstage/groups/:group_id/pictures' do |group_id|
    fixture_path = File.expand_path("../../test/fixtures/photo.jpeg", __FILE__)
    form = PictureForm.new file: File.new(fixture_path)
    use_case = AddPicture.new group_id, form, current_user

    picture = use_case.run!

    status 201
    json serialize(picture)
  end

  get '/groups/:group_id/pictures' do |group_id|
    use_case = GetPictures.new group_id, current_user
    json serialize(use_case.pictures, root: :pictures)
  end

  delete '/groups/:group_id/pictures/:picture_id' do |group_id, picture_id|
    use_case = DeletePicture.new group_id, picture_id, current_user
    use_case.run!
    nil
  end
end
