require_relative '../../test_helper'

class SetDeviceTest < AcceptanceTestCase
  attr_reader :user

  def setup
    super
    @user = create :user
  end

  def test_updates_the_users_device
    put '/device', { device: { uuid: 'foo', push_token: 'bar' }}, 'HTTP_X_TOKEN' => user.token
    assert_equal 200, last_response.status

    db = UserRepo.find user.id
    assert_equal 'foo', db.device.uuid
    assert_equal 'bar', db.device.push_token
  end

  def test_returns_the_device_as_json
    put '/device', { device: { uuid: 'foo', push_token: 'bar' }}, 'HTTP_X_TOKEN' => user.token
    assert_equal 200, last_response.status

    assert_includes last_response.content_type, 'application/json'
    json = JSON.parse(last_response.body).fetch('device')

    assert json.fetch('uuid')
    assert json.fetch('push_token')
  end

  def test_returns_a_412_when_auth_header_is_missing
    put '/device', { device: { uuid: 'foo', push_token: 'bar' }}
    assert_equal 412, last_response.status
  end

  def test_returns_a_403_when_token_incorrect
    put '/device', { device: { uuid: 'foo', push_token: 'bar' }}, 'HTTP_X_TOKEN' => 'foo'
    assert_equal 403, last_response.status
  end
end
