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
    Chassis::Repo.instance.clear
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

  def test_returns_the_user_as_json
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
    assert_includes last_response.content_type, 'application/json'

    json = JSON.load(last_response.body).fetch('user')

    assert json.fetch('name')
    assert json.fetch('token')

    json = json.fetch('device')

    assert json.fetch('uuid')
    assert json.fetch('push_token')
  end

  def test_returns_400_if_user_token_is_missing
    post '/user_token', user_token: nil
    assert_equal 400, last_response.status

    post '/user_token'
    assert_equal 400, last_response.status
  end

  def test_returns_422_if_phone_number_is_invalid
    post '/user_token', user_token: { phone_number: nil }
    assert_equal 422, last_response.status

    post '/user_token', user_token: { phone_number: '' }
    assert_equal 422, last_response.status

    post '/user_token', user_token: { phone_number: '3282314' }
    assert_equal 422, last_response.status
  end

  def test_returns_a_403_if_auth_code_is_bad
    assert_empty AuthTokenRepo

    post '/users', user: {
      name: 'Adam',
      auth_token: 'foo',
      device: {
        uuid: 'some-uuid',
        push_token: 'some-token'
      }
    }

    assert_equal 403, last_response.status
  end

  def test_returns_422_when_auth_token_is_blank
    post '/users', user: {
      name: 'Adam',
      auth_token: nil,
      device: {
        uuid: 'some-uuid',
        push_token: 'some-token'
      }
    }

    assert_equal 422, last_response.status
  end

  def test_returns_422_when_name_is_blank
    post '/users', user: {
      name: nil,
      auth_token: 'foo',
      device: {
        uuid: 'some-uuid',
        push_token: 'some-token'
      }
    }

    assert_equal 422, last_response.status
  end

  def test_raises_an_error_if_device_information_is_missing
    post '/user_token', user_token: { phone_number: "+19253736317" }
    assert_equal 202, last_response.status

    refute_empty sms.messages
    message = sms.messages.first
    assert_equal '+19253736317', message.number
    assert message.text, "SMS must contain the auth code"

    post '/users', user: {
      name: 'Adam',
      auth_token: message.text
    }

    assert_equal 422, last_response.status
  end

  def test_raises_an_error_if_device_id_is_invalid
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
        uuid: nil
      }
    }

    assert_equal 422, last_response.status

    post '/users', user: {
      name: 'Adam',
      auth_token: message.text,
      device: {
        uuid: ''
      }
    }

    assert_equal 422, last_response.status
  end
end
