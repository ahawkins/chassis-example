require_relative '../../test_helper'

class UpdateGroupTest < AcceptanceTestCase
  attr_reader :user, :group

  def setup
    super
    @user = create :user
    @group = create :group, admin: user
  end

  def test_blocks_users_who_arent_the_admin
    other_user = create :user
    refute_equal other_user, group.admin
    refute_equal other_user.token, user.token

    put "/groups/#{group.id}", { group: {
      name: 'Test',
      phone_numbers: [other_user.phone_number]
    }}, { 'HTTP_X_TOKEN' => other_user.token }

    assert_equal 403, last_response.status
  end

  def test_returns_a_404_for_unknown_groups
    put "/groups/asdfasdf", { group: {
      name: 'Test',
      phone_numbers: [user.phone_number]
    }}, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 404, last_response.status
  end

  def test_can_change_the_name
    put "/groups/#{group.id}", { group: {
      name: 'Test',
      phone_numbers: [user.phone_number]
    }}, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 200, last_response.status

    assert_equal 1, GroupRepo.count
    db = GroupRepo.first

    assert_equal 'Test', db.name
  end

  def test_can_change_users_by_sending_phone_numbers
    other_user = create :user

    put "/groups/#{group.id}", { group: {
      name: 'Test',
      phone_numbers: [other_user.phone_number]
    }}, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 200, last_response.status

    assert_equal 1, GroupRepo.count
    db = GroupRepo.first

    assert_equal [other_user], db.users
  end

  def test_new_users_recieve_a_push_notification
    other_user = create :user

    put "/groups/#{group.id}", { group: {
      name: 'Test',
      phone_numbers: [other_user.phone_number]
    }}, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 200, last_response.status

    assert_equal 1, push.notifications.count
    notification = push.notifications.first

    assert_kind_of NewGroupPushNotification, notification
    assert_equal group, notification.group
    assert_equal other_user, notification.user
  end

  def test_existing_users_dont_receive_a_push_notification
    existing_user, new_user = create(:user), create(:user)
    group.users = [user, existing_user]
    group.save

    put "/groups/#{group.id}", { group: {
      name: 'Test',
      phone_numbers: [
        user.phone_number,
        existing_user.phone_number,
        new_user.phone_number
      ]
    }}, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 200, last_response.status

    assert_equal 1, push.notifications.count
    notification = push.notifications.first

    assert_kind_of NewGroupPushNotification, notification
    assert_equal group, notification.group
    assert_equal new_user, notification.user
  end

  def test_returns_422_if_phone_number_does_not_exist
    put "/groups/#{group.id}", { group: {
      name: 'Test',
      phone_numbers: ['+12345']
    }}, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 422, last_response.status
    assert_includes last_response.content_type, 'application/json'
    assert JSON.load(last_response.body).fetch('errors')
  end

  def test_returns_422_if_phone_numbers_are_in_wrong_format
    put "/groups/#{group.id}", { group: {
      name: 'Test',
      phone_numbers: ['341328']
    }}, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 422, last_response.status
    assert_includes last_response.content_type, 'application/json'
    assert JSON.load(last_response.body).fetch('errors')
  end

  def test_requires_a_users_token
    put "/groups/#{group.id}", group: { name: 'test' }
    assert_equal 412, last_response.status
  end
end
