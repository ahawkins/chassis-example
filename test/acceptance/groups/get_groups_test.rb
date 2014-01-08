require_relative '../../test_helper'

class GetGroupsTest < AcceptanceTestCase
  attr_reader :user

  def setup
    super
    @user = create :user
  end

  def test_returns_all_groups_the_user_is_in
    group = create :group, users: [user]

    get '/groups', { }, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 200, last_response.status
    assert_includes last_response.content_type, 'application/json'

    json = JSON.load(last_response.body).fetch('groups')

    assert_kind_of Array, json
    assert_equal 1, json.length
  end

  def test_can_find_groups_updated_after_a_certain_time
    group_a = create :group, users: [user]

    group_b = Time.stub :now, Time.now - 23838 do
      create :group, users: [user]
    end

    assert(group_b.updated_at < group_a.updated_at, "Precondition: timestamps must be correct")

    get '/groups', { updated_after: group_a.updated_at.utc.iso8601}, { 
      'HTTP_X_TOKEN' => user.token
    }

    assert_equal 200, last_response.status
    assert_includes last_response.content_type, 'application/json'

    json = JSON.load(last_response.body).fetch('groups')

    assert_kind_of Array, json
    assert_equal 1, json.length

    json_ids = json.map { |g| g.fetch('id') }
    assert_equal [group_a.id.to_s], json_ids
  end

  def test_requires_a_user
    get '/groups'
    assert_equal 412, last_response.status
  end
end
