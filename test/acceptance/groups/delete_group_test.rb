require_relative '../../test_helper'

class DeleteGroupTest < AcceptanceTestCase
  attr_reader :user, :group

  def setup
    super
    @user = create :user
    @group = create :group, admin: user
  end

  def test_deletes_the_group_from_the_db
    delete "/groups/#{group.id}", { }, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 200, last_response.status
    assert_empty last_response.body

    assert_empty GroupRepo
  end

  def test_only_admin_can_delete_group
    other_user = create :user
    delete "/groups/#{group.id}", { }, { 'HTTP_X_TOKEN' => other_user.token }

    assert_equal 403, last_response.status
  end
end
