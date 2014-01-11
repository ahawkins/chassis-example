require_relative '../test_helper'

class ImageServiceTest < MiniTest::Unit::TestCase
  attr_reader :image_service

  FileUpload = Struct.new :path, :content_type

  def photo_path
    File.expand_path '../../fixtures/photo.jpeg', __FILE__
  end

  def setup
    ImageService.backend = ImageService::Cloudinary.new cloudinary_url
  end

  def test_round_trips_images
    photo = FileUpload.new photo_path, 'image/jpeg'
    ImageService.upload photo
  end
end
