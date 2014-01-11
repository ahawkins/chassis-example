class PictureForm < Form
  class ImageUpload < Virtus::Attribute
    def coerce(value)
      if value.is_a?(::Hash)
        MultipartImageUpload.new value
      elsif value.is_a?(File)
        ImageFileUpload.new value
      end
    end
  end

  attribute :file, ImageUpload
end
