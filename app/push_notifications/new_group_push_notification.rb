class NewGroupPushNotification
  attr_reader :group, :user

  def initialize(group, user)
    @group, @user = group, user
  end
end
