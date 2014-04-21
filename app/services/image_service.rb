class ImageService
  RequestError = Class.new StandardError

  extend Chassis.strategy(:upload, :store, :delete, :exists?, :clear)
end

require_relative 'image_service/cloudinary_image_service'
require_relative 'image_service/fake_image_service'
