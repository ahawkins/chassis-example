class Device
  include Persistance
  include Serialization
  include Chassis::HashInitializer

  attr_accessor :uuid, :push_token
end
