class ImageService
  cattr_accessor :backend

  class NullBackend
    class UploadResult
      attr_accessor :id, :full_size_url, :thumbnail_url
      attr_accessor :width, :height

      class << self
        def generate
          result = new
          result.id = SecureRandom.hex 8

          result.full_size_url = "http://fake.com/picture_full_size.png"
          result.thumbnail_url = "http://fake.com/picture_thumbnail.png"

          result.width = 150
          result.height = 200

          result
        end
      end
    end

    def upload(file)
      UploadResult.generate
    end
  end

  class << self
    def upload(file)
      backend.upload file
    end
  end
end
