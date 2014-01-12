require_relative '../../test_helper'

class CreatePictureTest < AcceptanceTestCase
  attr_reader :user, :group, :photo_file

  def setup
    super
    @user = create :user
    @group = create :group, admin: user
    @photo_file = Rack::Test::UploadedFile.new fixture_path.join("photo.jpeg"), "image/jpeg"
  end

  def fixture_path
    Pathname.new File.expand_path("../../../fixtures", __FILE__)
  end

  def test_uploads_the_picture
    post "/groups/#{group.id}/pictures", { picture: {
      file: photo_file
    }}, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 201, last_response.status

    db = GroupRepo.first
    refute_empty db.pictures
  end

  def test_works_with_fake_pictures
    post "/backstage/groups/#{group.id}/pictures", { }, { 
      'HTTP_X_TOKEN' => user.token
    }

    assert_equal 201, last_response.status

    db = GroupRepo.first
    refute_empty db.pictures
  end

  def test_returns_the_picture_as_json
    post "/groups/#{group.id}/pictures", { picture: {
      file: photo_file
    }}, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 201, last_response.status
    assert_includes last_response.content_type, 'application/json'

    json = JSON.parse(last_response.body).fetch('picture')

    assert_kind_of String, json.fetch('id')

    assert_kind_of Hash, json.fetch('user'), "User should be embedded"

    assert json.fetch('full_size_url')
    assert json.fetch('thumbnail_url')

    assert_kind_of Fixnum, json.fetch('height')
    assert_kind_of Fixnum, json.fetch('width')
    assert_kind_of Fixnum, json.fetch('bytes')

    assert_iso8601 json.fetch('date')
  end

  def test_only_group_members_can_upload_files
    other_user = create :user

    post "/groups/#{group.id}/pictures", { picture: {
      file: photo_file
    }}, { 'HTTP_X_TOKEN' => other_user.token }

    assert_equal 403, last_response.status
  end

  def test_requires_a_file
    post "/groups/#{group.id}/pictures", { picture: {
      file: nil
    }}, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 422, last_response.status
  end

  def test_sends_push_notification_to_the_group_members
    other_user = create :user
    @group = create :group, users: [user, other_user]

    post "/groups/#{group.id}/pictures", { picture: {
      file: photo_file
    }}, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 201, last_response.status

    db = GroupRepo.find group.id
    assert_equal 1, db.pictures.count
    picture = db.pictures.first

    assert_equal 1, push.notifications.count
    notification = push.notifications.first

    assert_kind_of NewPicturePushNotification, notification
    assert_equal picture, notification.picture
    assert_equal other_user, notification.user
  end

  def test_becomes_the_cover_when_there_are_no_existing_images
    assert_empty group.pictures, "Precondition: group must have no pictures"

    post "/groups/#{group.id}/pictures", { picture: {
      file: photo_file
    }}, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 201, last_response.status

    db = GroupRepo.first
    refute_empty db.pictures
    picture = db.pictures.first

    assert_equal picture, db.cover
  end

  def test_getting_a_group_includes_picture_information
    post "/groups/#{group.id}/pictures", { picture: {
      file: photo_file
    }}, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 201, last_response.status

    get "/groups/#{group.id}", { }, { 'HTTP_X_TOKEN' => user.token }

    assert_equal 200, last_response.status
    assert_includes last_response.content_type, 'application/json'
    json = JSON.parse(last_response.body).fetch('group')

    assert_kind_of Fixnum, json.fetch('total_pictures')
    assert_kind_of Hash, json.fetch('cover')
    assert_kind_of Array, json.fetch('pictures')
  end
end
