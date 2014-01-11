class MultipartImageUpload
  attr_reader :hash

  def initialize(hash)
    @hash = hash
  end

  def bytes
    tempfile.size
  end

  def path
    tempfile.path
  end

  def content_type
    hash.fetch :type
  end

  private
  def tempfile
    hash.fetch :tempfile
  end
end

