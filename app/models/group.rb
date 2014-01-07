class Group
  include Persistance
  include Serialization
  include Chassis::HashInitializer

  attr_accessor :name, :admin, :users
  attr_accessor :created_at, :updated_at
end
