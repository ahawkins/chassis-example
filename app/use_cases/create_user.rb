class CreateUser
  attr_reader :form

  def initialize(form)
    @form = form
  end

  def run!
    auth_token = AuthTokenRepo.find_by_code! form.auth_token

    user = User.create do |user|
      user.name = form.name
      user.phone_number = auth_token.phone_number
      user.token = SecureRandom.hex(32)
      user.device = Device.new do |device|
        device.uuid = form.device.fetch('uuid')
        device.push_token = form.device.fetch('push_token')
      end
    end
  end
end
