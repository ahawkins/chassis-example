ENV['RACK_ENV'] = 'test'

root = File.expand_path '../../', __FILE__
require "#{root}/app"

require 'minitest/autorun'
require 'minitest/mock'
require 'rack/test'
require 'pathname'

require_relative 'support/sidekiq'
require_relative 'support/fabrication'
require_relative 'support/backtrace_silencer'
require_relative 'support/webmock'

class MiniTest::Test
  def cloudinary_url
    'cloudinary://152823543227467:8c7WbzmM4Rk7Dl1RZsnR_RIpD3k@haeunwn44'
  end

  def ci?
    ENV.key? 'CI'
  end

  def image_service
    ImageService
  end

  def sms
    SmsService
  end

  def push
    PushService
  end
end

class AcceptanceTestCase < MiniTest::Test
  include Rack::Test::Methods

  def app
    WebService
  end

  def create(*args)
    Fabricate(*args)
  end

  def repo_implementation
    if ci?
      :redis
    else
      :memory
    end
  end

  def image_service_implementation
    if ci?
      :cloudinary
    else
      :fake
    end
  end

  def setup
    SmsService.use :fake
    SmsService.clear

    PushService.use :fake
    PushService.clear

    ImageService.use image_service_implementation
    ImageService.clear

    Chassis.repo.use repo_implementation
    Chassis.repo.clear
  end

  def assert_iso8601(value)
    assert_match /\A\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}Z\z/, value, "Timestamp must be ISO 8601"
  end
end
