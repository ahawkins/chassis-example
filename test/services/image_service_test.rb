require_relative '../test_helper'

class ImageServiceTest < MiniTest::Test
  attr_reader :image_service

  def photo_path
    File.expand_path '../../fixtures/photo.jpeg', __FILE__
  end

  def setup
    @image_service = CloudinaryImageService.new cloudinary_url
  end

  def test_round_trips_images
    photo = ImageFile.new photo_path, 'image/jpeg'
    image_service.upload photo
  end
end
