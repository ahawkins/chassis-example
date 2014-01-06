class User
  include Persistance
  include Chassis::HashInitializer

  attr_accessor :name, :phone_number, :token, :device
end
