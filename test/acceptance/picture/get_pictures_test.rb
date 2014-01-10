require_relative '../../test_helper'

class GetPicturesTest < AcceptanceTestCase
  attr_reader :user, :group, :picture

  def setup
    super
    @user = create :user
    @group = create :group, users: [user]
    @picture = create :picture

    group.pictures << picture
    group.save
  end

  def test_returns_the_pictures_as_json
    get "/groups/#{group.id}/pictures", { }, {
      'HTTP_X_TOKEN' => user.token
    }

    assert_equal 200, last_response.status
    assert_includes last_response.content_type, "application/json"
    json = JSON.parse(last_response.body).fetch('pictures')

    assert_kind_of Array, json
    assert_equal 1, json.size
  end

  def test_does_not_allow_users_outside_the_group
    other_user = create :user

    get "/groups/#{group.id}/pictures", { }, {
      'HTTP_X_TOKEN' => other_user.token
    }

    assert_equal 403, last_response.status
  end
end
