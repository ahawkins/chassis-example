class GetPictures
  attr_reader :group_id, :current_user

  def initialize(group_id, current_user)
    @group_id, @current_user = group_id, current_user
  end

  def pictures
    group = GroupRepo.find group_id

    authorize! group

    group.pictures
  end

  def authorize!(group)
    if !group.member? current_user
      raise PermissionDeniedError, "Only group members can read pictures"
    end
  end
end
