class Hash
  def to_image_file
    image_file = ImageFile.new
    image_file.path = fetch(:tempfile).path
    image_file.content_type = fetch(:type)
    image_file
  end
end
