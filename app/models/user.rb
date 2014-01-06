class User
  include Persistance
  include Serialization
  include Chassis::HashInitializer

  attr_accessor :name, :phone_number, :token, :device
end
