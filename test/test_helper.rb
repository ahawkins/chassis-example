ENV['RACK_ENV'] = 'test'

root = File.expand_path '../../', __FILE__
require "#{root}/app"

require 'minitest/autorun'
require 'rack/test'
require 'fabrication'

require 'sidekiq/testing'
Sidekiq::Testing.fake!

require 'webmock/minitest'
WebMock.disable_net_connect!

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

class AcceptanceTestCase < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  class FakeSms
    Sms = Struct.new :number, :text

    attr_reader :messages

    def initialize
      @messages = [ ]
    end

    def deliver(number, msg)
      messages << Sms.new(number, msg)
    end
  end

  class FakePush
    attr_reader :notifications

    def initialize
      @notifications = [ ]
    end

    def push(notification)
      notifications << notification
    end
  end

  def app
    WebService
  end

  def sms
    SmsService.backend
  end

  def push
    PushService.backend
  end

  def create(*args)
    Fabricate(*args)
  end

  def setup
    SmsService.backend = FakeSms.new
    PushService.backend = FakePush.new

    Chassis::Repo.backend = RedisAdapter.new
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
