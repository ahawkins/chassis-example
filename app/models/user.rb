class User
  include Chassis::Persistence
  include Serialization

  attr_accessor :name, :phone_number, :token, :device

  def push?
    !!device.push_token
  end

  def save
    raise "Users must have tokens!" unless token
    super
  end
end
