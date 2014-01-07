require 'bundler/setup'
require 'chassis'
require 'sidekiq'
require 'securerandom'
require 'faraday'
require 'redis-namespace'

require 'sinatra/json'

require 'active_support/concern'
require 'active_support/core_ext/class'
require 'active_support/core_ext/string'

require 'active_model_serializers'

I18n.enforce_available_locales = false

require_relative 'app/utils'

require_relative 'app/models/concerns/persistance'
require_relative 'app/models/concerns/serialization'
require_relative 'app/models/auth_token'
require_relative 'app/models/device'
require_relative 'app/models/user'
require_relative 'app/models/group'

require_relative 'app/services/sms_service'

require_relative 'app/repos/auth_token_repo'
require_relative 'app/repos/user_repo'
require_relative 'app/repos/group_repo'

require_relative 'app/repos/adapters/in_memory_adapter'
require_relative 'app/repos/adapters/redis_adapter'

require_relative 'app/form'
require_relative 'app/forms/user_token_form'
require_relative 'app/forms/create_user_form'
require_relative 'app/forms/device_form'
require_relative 'app/forms/group_form'

require_relative 'app/use_cases/send_user_token'
require_relative 'app/use_cases/create_user'
require_relative 'app/use_cases/update_device'
require_relative 'app/use_cases/create_group'

require_relative 'app/jobs/deliver_auth_token'

require_relative 'app/serializers/user_serializer'
require_relative 'app/serializers/device_serializer'
require_relative 'app/serializers/group_serializer'

require_relative 'app/web_service'

module App

  class << self
    def env
      ENV.fetch 'RACK_ENV', 'development'
    end
  end
end

root = File.dirname __FILE__
config_file = "#{root}/config/#{App.env}.rb"
require config_file
