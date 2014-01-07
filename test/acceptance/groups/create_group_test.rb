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
end
