require_relative '../../test_helper'

class DeletePictureTest < AcceptanceTestCase
  attr_reader :user, :group, :picture

  def setup
    super
    @user = create :user
    @group = create :group, users: [user]
    @picture = create :picture, user: user

    group.pictures << picture
    group.save
  end

  def test_removes_the_picture_from_the_group
    delete "/groups/#{group.id}/pictures/#{picture.id}", { }, {
      'HTTP_X_TOKEN' => user.token
    }

    assert_equal 200, last_response.status

    db = GroupRepo.first
    assert_empty db.pictures
  end

  def test_deletes_the_image_from_the_image_service
    assert image_service.exists?(picture.id), "Precondtion: Image must be in the image service"

    delete "/groups/#{group.id}/pictures/#{picture.id}", { }, {
      'HTTP_X_TOKEN' => user.token
    }

    assert_equal 200, last_response.status
    refute image_service.exists?(picture.id), "Images should be deleted remotely"
  end

  def test_response_does_not_have_a_body
    delete "/groups/#{group.id}/pictures/#{picture.id}", { }, {
      'HTTP_X_TOKEN' => user.token
    }

    assert_equal 200, last_response.status
    assert_empty last_response.body
  end

  def test_denies_users_who_didnt_post_it
    other_user = create :user

    group.users << other_user
    group.save

    delete "/groups/#{group.id}/pictures/#{picture.id}", { }, {
      'HTTP_X_TOKEN' => other_user.token
    }

    assert_equal 403, last_response.status
  end

  def test_allows_the_admin_to_delete
    assert_equal picture.group, group, "Precondition: groups must be equal"

    delete "/groups/#{group.id}/pictures/#{picture.id}", { }, {
      'HTTP_X_TOKEN' => group.admin.token
    }

    assert_equal 200, last_response.status
  end
end
