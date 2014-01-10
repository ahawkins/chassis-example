class Group
  include Persistance
  include Serialization
  include Chassis::HashInitializer

  attr_accessor :name, :admin, :users, :pictures
  attr_accessor :cover
  attr_accessor :created_at, :updated_at

  def initialize(*args, &block)
    super
    @pictures ||= []
  end

  def save
    self.created_at = Time.now.utc if new_record?
    self.updated_at = Time.now.utc
    super
  end

  def total_pictures
    pictures.size
  end

  def member?(user)
    users.include? user
  end
end
