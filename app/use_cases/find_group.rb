class FindGroup
  attr_reader :group_id, :current_user

  def initialize(group_id, current_user)
    @group_id, @current_user = group_id, current_user
  end

  def group
    record = GroupRepo.find group_id

    authorize! record

    record
  end

  private
  def authorize!(record)
    if !record.member? current_user
      raise PermissionDeniedError, "Only group members by access groups"
    end
  end
end
