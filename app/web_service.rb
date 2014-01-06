class WebService < Sinatra::Base
  use Chassis::Rack::Ping
  use Chassis::Rack::Bouncer
  use Rack::BounceFavicon

  use Chassis::Rack::Instrumentation
  use Manifold::Middleware
  use Rack::Deflater

  use Rack::PostBodyContentTypeParser

  helpers do
    def extract!(key)
      params.fetch(key.to_s) do
        raise ParamterMissingError, key
      end
    end

    def serialize(object, options = {})
      klass = options[:serializer] || object.active_model_serializer
      serializer = klass.new(object)#options.merge(scope: current_user))
      serializer.as_json
    end
  end

  post '/user_token' do
    form = UserTokenForm.new extract!(:user_token)
    use_case = SendUserToken.new form
    use_case.run!

    status 202
  end

  post '/users' do
    form = CreateUserForm.new extract!(:user)
    use_case = CreateUser.new form

    user = use_case.run!

    status 201
  end
end
