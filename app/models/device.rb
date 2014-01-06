class Device
  include Persistance
  include Chassis::HashInitializer

  attr_accessor :uuid, :push_token
end
