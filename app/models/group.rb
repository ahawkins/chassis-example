class Group
  include Persistance
  include Serialization
  include Chassis::HashInitializer

  attr_accessor :name, :admin, :users
  attr_accessor :created_at, :updated_at

  def save
    self.created_at = Time.now.utc if new_record?
    self.updated_at = Time.now.utc
    super
  end
end
