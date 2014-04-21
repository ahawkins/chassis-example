class Device
  include Chassis::Persistence
  include Serialization

  attr_accessor :uuid, :push_token
end
