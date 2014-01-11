class ImageService
  class FakeBackend
    class UploadResult
      attr_accessor :id, :full_size_url, :thumbnail_url
      attr_accessor :width, :height, :bytes

      class << self
        def generate
          result = new
          result.id = SecureRandom.hex 8

          result.full_size_url = "http://fake.com/picture_full_size.png"
          result.thumbnail_url = "http://fake.com/picture_thumbnail.png"

          result.width = 150
          result.height = 200
          result.bytes = 1024

          result
        end
      end
    end

    def initialize
      @images = []
    end

    def upload(file)
      result = UploadResult.generate
      images << result
      result
    end

    def exists?(id)
      !!images.find do |picture|
        picture.id == id
      end
    end

    def delete(id)
      images.delete_if do |picture|
        picture.id == id
      end
    end

    private
    def images
      @images
    end
  end
end
