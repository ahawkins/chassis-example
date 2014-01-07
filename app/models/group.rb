class Group
  include Persistance
  include Serialization
  include Chassis::HashInitializer

  attr_accessor :name, :admin
  attr_accessor :created_at, :updated_at
end
