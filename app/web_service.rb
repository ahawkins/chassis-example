class WebService < Sinatra::Base
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

  helpers do
    def extract!(key)
      value = params.fetch(key.to_s) do
        raise ParameterMissingError, key
      end

      raise ParameterMissingError, key unless value.is_a?(Hash)

      value
    end

    def serialize(object, options = {})
      klass = options[:serializer] || object.active_model_serializer
      serializer = klass.new(object)#options.merge(scope: current_user))
      serializer.as_json
    end
  end

  error ParameterMissingError do
    halt 400, { 'Content-Type' => 'application/json' }, JSON.dump(message: env['sinatra.error'].message)
  end

  error Validation::ValidationFailedError do
    halt 422, { 'Content-Type' => 'application/json' }, JSON.dump({
      message: 'validation failed',
      errors: env['sinatra.error'].as_json
    })
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
    rescue CreateUser::UnknownAuthCodeError => ex
      halt 403, { 'Content-Type' => 'application/json' }, JSON.dump(message: ex.message)
    end
  end
end
