class File
  def to_image_file
    image_file = ImageFile.new
    image_file.path = path
    image_file.content_type = 'image/jpeg'
    image_file
  end
end
