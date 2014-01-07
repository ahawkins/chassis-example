require_relative '../../test_helper'

class CreateGroupTest < AcceptanceTestCase
  attr_reader :user

  def setup
    super
    @user = create :user
  end

  def test_saves_the_group_in_the_db
    post '/groups', { group: {
      name: 'Test'
    }}, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 201, last_response.status

    assert_equal 1, GroupRepo.count
    group = GroupRepo.first

    assert_equal 'Test', group.name
    assert_kind_of Time, group.created_at
    assert group.created_at.utc?, "Times must be UTC"
    assert_kind_of Time, group.updated_at
    assert group.updated_at.utc?, "Times must be UTC"

    assert_equal user, group.admin,
      "Groups must be admined by the user who created them"
  end

  def test_adds_users_to_the_group_by_phone_numbers
    other_user = create :user, phone_number: '+12345'

    post '/groups', { group: {
      name: 'Test',
      phone_numbers: ['+12345']
    }}, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 201, last_response.status

    assert_equal 1, GroupRepo.count
    group = GroupRepo.first

    refute_empty group.users
    assert_includes group.users, other_user
    assert_includes group.users, user
  end

  def test_returns_the_group_as_json
    post '/groups', { group: {
      name: 'Test'
    }}, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 201, last_response.status

    assert_includes last_response.content_type, 'application/json'
    json = JSON.load(last_response.body).fetch('group')

    assert_kind_of String, json.fetch('id')
    assert json.fetch('name')
    assert_iso8601 json.fetch('created_at')
    assert_iso8601 json.fetch('updated_at')
  end

  def test_requires_a_name
    post '/groups', { group: {
      name: nil
    }}, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 422, last_response.status

    assert_includes last_response.content_type, 'application/json'
    json = JSON.load(last_response.body)

    assert json.fetch('message')
    assert json.fetch('errors')
  end

  def test_requires_a_users_token
    post '/groups', group: { name: 'test' }
    assert_equal 412, last_response.status
  end
end
