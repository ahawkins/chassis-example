class NewPicturePushNotification
  attr_reader :picture, :user

  def initialize(picture, user)
    @picture, @user = picture, user
  end
end
