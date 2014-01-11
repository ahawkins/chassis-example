Fabricator :picture do
  id { SecureRandom.hex 8 }
  full_size_url 'http://fake.com/full.png'
  thumbnail_url 'http://fake.com/thumbnail.png'
  height 100
  width 100
  bytes 200
  user

  before_save do |picture|
    fixture_photo = File.expand_path('../../fixtures/photo.jpeg', __FILE__)
    result = ImageService.upload(ImageFile.new(fixture_photo, 'image/jpeg'))
    picture.id = result.id
  end
end
