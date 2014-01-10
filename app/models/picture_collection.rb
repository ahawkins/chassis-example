class PictureCollection
  include Enumerable

  def initialize(group)
    @group = group
    @collection = []
  end

  def each(*args, &block)
    collection.each *args, &block
  end

  def <<(picture)
    collection << picture
    picture.group = group
  end
  alias push <<

  def size
    collection.size
  end

  def active_model_serializer
    collection.active_model_serializer
  end

  def empty?
    collection.empty?
  end

  def delete(picture)
    collection.delete picture
  end

  private
  def group
    @group
  end

  def collection
    @collection
  end
end
