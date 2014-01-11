ENV['RACK_ENV'] = 'test'

root = File.expand_path '../../', __FILE__
require "#{root}/app"

require 'minitest/autorun'
require 'minitest/mock'
require 'rack/test'
require 'fabrication'
require 'pathname'

require 'sidekiq/testing'
Sidekiq::Testing.fake!

require 'webmock/minitest'
WebMock.disable_net_connect! allow: /cloudinary/

class BacktraceFilter
  def filter(bt)
    return ["No backtrace"] unless bt

    return bt.dup if $DEBUG

    bt.select { |line| line.include? root }
  end

  def root
    File.expand_path("../../", __FILE__)
  end
end

MiniTest.backtrace_filter = BacktraceFilter.new

class MiniTest::Unit::TestCase
  def cloudinary_url
    'cloudinary://152823543227467:8c7WbzmM4Rk7Dl1RZsnR_RIpD3k@haeunwn44'
  end

  def ci?
    ENV.key? 'CI'
  end

  def image_service
    ImageService.backend
  end

  def sms
    SmsService.backend
  end

  def push
    PushService.backend
  end
end

class AcceptanceTestCase < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    WebService
  end

  def create(*args)
    Fabricate(*args)
  end

  def repo_adapter
    if ci?
      RedisAdapter.new
    else
      InMemoryAdapter.new
    end
  end

  def image_service_adapter
    if ci?
      ImageService::CloudinaryBackend.new cloudinary_url
    else
      ImageService::FakeBackend.new
    end
  end

  def setup
    SmsService.backend = SmsService::FakeBackend.new
    PushService.backend = PushService::FakeBackend.new
    ImageService.backend = image_service_adapter

    Chassis::Repo.backend = repo_adapter
    Chassis::Repo.instance.initialize_storage!
    Chassis::Repo.instance.clear

    Sidekiq::Testing.fake!
  end

  def teardown
    Sidekiq::Testing.fake!
  end

  def assert_iso8601(value)
    assert_match /\A\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}Z\z/, value, "Timestamp must be ISO 8601"
  end
end
