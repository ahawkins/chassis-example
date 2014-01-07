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
  end
end
