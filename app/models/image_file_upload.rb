class ImageFileUpload
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def bytes
    file.size
  end

  def path
    file.path
  end

  def content_type
    'image/jpeg'
  end
end

