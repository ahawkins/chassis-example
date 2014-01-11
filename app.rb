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
require 'active_support/core_ext/hash'

require 'active_model_serializers'

I18n.enforce_available_locales = false

module App
  class << self
    def env
      ENV.fetch 'RACK_ENV', 'development'
    end

    def phone_number_regex
      /\A\+\d+\z/
    end
  end
end

PermissionDeniedError = Class.new StandardError

class ValidationError < StandardError
  attr_reader :errors

  def initialize(errors)
    @errors = errors
  end

  def to_s
    errors.full_messages
  end

  def as_json
    errors.as_json
  end
end

require_relative 'app/utils'

require_relative 'app/models/concerns/persistance'
require_relative 'app/models/concerns/serialization'
require_relative 'app/models/auth_token'
require_relative 'app/models/device'
require_relative 'app/models/user'
require_relative 'app/models/group'
require_relative 'app/models/picture'
require_relative 'app/models/picture_collection'
require_relative 'app/models/image_file_upload'
require_relative 'app/models/multipart_image_upload'

require_relative 'app/services/sms_service'
require_relative 'app/services/push_service'
require_relative 'app/services/image_service'

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
require_relative 'app/forms/groups_query_form'
require_relative 'app/forms/picture_form'

require_relative 'app/use_cases/send_user_token'
require_relative 'app/use_cases/create_user'
require_relative 'app/use_cases/update_device'
require_relative 'app/use_cases/create_group'
require_relative 'app/use_cases/update_group'
require_relative 'app/use_cases/query_groups'
require_relative 'app/use_cases/delete_group'
require_relative 'app/use_cases/find_group'
require_relative 'app/use_cases/add_picture'
require_relative 'app/use_cases/get_pictures'
require_relative 'app/use_cases/delete_picture'

require_relative 'app/push_notifications/new_group_push_notification'
require_relative 'app/push_notifications/new_picture_push_notification'

require_relative 'app/serializers/user_serializer'
require_relative 'app/serializers/device_serializer'
require_relative 'app/serializers/group_serializer'
require_relative 'app/serializers/picture_serializer'

require_relative 'app/web_service'

root = File.dirname __FILE__
config_file = "#{root}/config/#{App.env}.rb"
require config_file

SmsService.backend ||= SmsService::NullBackend.new
PushService.backend ||= PushService::NullBackend.new
ImageService.backend ||= ImageService::NullBackend.new
