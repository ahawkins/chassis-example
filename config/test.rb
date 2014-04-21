cloudinary_uri = 'cloudinary://152823543227467:8c7WbzmM4Rk7Dl1RZsnR_RIpD3k@haeunwn44'
ImageService.register :cloudinary, CloudinaryImageService.new(cloudinary_uri)

Chassis.repo.register :redis, RedisRepo.new(Redis.new)
