require_relative '../test_helper'

class ImageServiceTest < MiniTest::Test
  def image_service_implementation
    :cloudinary
  end

  def photo_path
    File.expand_path '../../fixtures/photo.jpeg', __FILE__
  end

  def test_round_trips_images
    photo = ImageFile.new photo_path, 'image/jpeg'
    image_service.upload photo
  end
end
