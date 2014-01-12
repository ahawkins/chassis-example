class PictureForm < Form
  class ImageUpload < Virtus::Attribute
    def coerce(value)
      value.respond_to?(:to_image_file) ? value.to_image_file : value
    end
  end

  attribute :file, ImageUpload

  validates :file, presence: true
end
