Fabricator :picture do
  id { SecureRandom.hex 8 }
  full_size_url 'http://fake.com/full.png'
  thumbnail_url 'http://fake.com/thumbnail.png'
  height 100
  width 100
  bytes 200
  user
end
