class UpdateGroup
  attr_reader :group_id, :form, :current_user

  def initialize(group_id, form, current_user)
    @group_id, @form, @current_user = group_id, form, current_user
  end

  def run!
    form.validate!
    PhoneNumbersValidator.new(form.phone_numbers).validate!

    group = GroupRepo.find group_id
    authorize! group

    previous_users = group.users.dup

    group.name = form.name

    group.users = form.phone_numbers.map do |number|
      UserRepo.find_by_phone_number! number
    end

    new_users = group.users - previous_users
    new_users.each do |user|
      PushService.push NewGroupPushNotification.new(group, user)
    end

    group.save

    group
  end

  private
  def authorize!(group)
    if group.admin != current_user
      raise PermissionDeniedError, "only admins can manage groups"
    end
  end
end
