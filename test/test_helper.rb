ENV['RACK_ENV'] = 'test'

root = File.expand_path '../../', __FILE__
require "#{root}/app"

require 'minitest/autorun'

require 'rack/test'

require 'sidekiq/testing'
Sidekiq::Testing.fake!

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

  def app
    WebService
  end

  def sms
    SmsService.backend
  end

  def setup
    SmsService.backend = FakeSms.new
    Chassis::Repo.backend = InMemoryAdapter.new
    Chassis::Repo.backend.initialize_storage!
    Chassis::Repo.instance.clear
    Sidekiq::Testing.inline!
  end

  def teardown
    Sidekiq::Testing.fake!
  end
end
