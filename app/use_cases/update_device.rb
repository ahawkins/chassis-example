class UpdateDevice
  attr_reader :form, :current_user

  def initialize(form, current_user)
    @form, @current_user = form, current_user
  end

  def run!
    form.validate!

    current_user.device.uuid = form.uuid
    current_user.device.push_token = form.push_token

    current_user.save

    current_user.device
  end
end
