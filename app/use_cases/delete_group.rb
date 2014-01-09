class DeleteGroup
  attr_reader :group_id, :current_user

  def initialize(group_id, current_user)
    @group_id, @current_user = group_id, current_user
  end

  def run!
    group = GroupRepo.find group_id

    authorize! group

    group.destroy

    true
  end

  def authorize!(group)
    if group.admin != current_user
      raise PermissionDeniedError, "only admins can manage groups"
    end
  end
end
