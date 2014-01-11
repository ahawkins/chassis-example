class AddPicture
  attr_reader :group_id, :form, :current_user

  def initialize(group_id, form, current_user)
    @group_id, @form, @current_user = group_id, form, current_user
  end

  def run!
    group = GroupRepo.find group_id

    authorize! group

    cloud = ImageService.upload form.file

    picture = Picture.new do |picture|
      picture.user = current_user

      picture.date = Time.now.utc

      picture.id = cloud.id

      picture.full_size_url = cloud.full_size_url
      picture.thumbnail_url = cloud.thumbnail_url

      picture.bytes = cloud.bytes
      picture.width = cloud.width
      picture.height = cloud.height
    end

    group.cover = picture if group.pictures.empty?

    group.pictures << picture

    group.save

    group.users.each do |recipient|
      next if recipient == current_user
      PushService.push(NewPicturePushNotification.new(picture, recipient))
    end

    picture
  end

  def authorize!(group)
    if !group.member? current_user
      raise PermissionDeniedError, "Only group members can add pictures"
    end
  end
end
