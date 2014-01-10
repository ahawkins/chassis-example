class DeletePicture
  class UnknownPictureError < StandardError
    def initialize(id)
      @id = id
    end

    def to_s
      "Cannot find picture #{id}"
    end
  end

  attr_reader :group_id, :picture_id, :current_user

  def initialize(group_id, picture_id, current_user)
    @group_id, @picture_id, @current_user = group_id, picture_id, current_user
  end

  def run!
    group = GroupRepo.find group_id

    picture = group.pictures.find do |picture|
      picture.id == picture_id
    end

    raise UnknownPictureError, picture_id unless picture

    authorize! picture

    ImageService.delete picture.id

    group.pictures.delete picture

    group.save

    true
  end

  def authorize!(picture)
    if picture.user != current_user
      raise PermissionDeniedError, "Only the upload may delete pictures"
    end
  end
end
