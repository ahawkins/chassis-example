class ImageService
  class FakeBackend
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

    def initialize
      @images = []
    end

    def upload(file)
      UploadResult.generate
    end

    def store(picture)
      images << picture
    end

    def empty?
      images.empty?
    end

    def delete(id)
      images.delete_if do |picture|
        picture.id == id
      end
    end

    def clear
      images.clear
    end

    private
    def images
      @images
    end
  end
end
