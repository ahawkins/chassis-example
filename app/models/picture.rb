class Picture
  include Serialization
  include Chassis::HashInitializer

  attr_accessor :group, :user
  attr_accessor :id
  attr_accessor :full_size_url, :thumbnail_url
  attr_accessor :height, :width, :bytes
  attr_accessor :date

  def ==(other)
    other.instance_of?(self.class) && id == other.id
  end

  def eql?(other)
    self == other
  end
end
