class Group
  include Persistance
  include Serialization
  include Chassis::HashInitializer

  attr_accessor :name
end
