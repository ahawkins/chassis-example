require_relative '../../test_helper'

class CreateUserTest < MiniTest::Unit::TestCase
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
    Sidekiq::Testing.inline!
  end

  def teardown
    Sidekiq::Testing.fake!
  end

  def test_uses_the_auth_code_to_create_a_user
    post '/user_token', user_token: { phone_number: "+19253736317" }
    assert_equal 202, last_response.status

    refute_empty sms.messages
    message = sms.messages.first
    assert_equal '+19253736317', message.number
    assert message.text, "SMS must contain the auth code"

    post '/users', user: {
      name: 'Adam',
      auth_token: message.text,
      device: {
        uuid: 'some-uuid',
        push_token: 'some-token'
      }
    }

    assert_equal 201, last_response.status

    assert_equal 1, UserRepo.count
    db = UserRepo.first

    assert_equal 'Adam', db.name
    assert_equal '+19253736317', db.phone_number

    assert_equal 'some-uuid', db.device.uuid
    assert_equal 'some-token', db.device.push_token
  end
end
