class ImageService
  cattr_accessor :backend

  class << self
    def upload(file)
      backend.upload file
    end

    def store(picture)
      backend.store picture
    end

    def delete(id)
      backend.delete id
    end

    def clear
      backend.clear
    end
  end
end

require_relative 'image_service/cloudinary_backend'
require_relative 'image_service/fake_backend'
