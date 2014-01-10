class PictureForm < Form
  class ImageUpload < Virtus::Attribute
    class MultipartImageUpload
      attr_reader :hash

      def initialize(hash)
        @hash = hash
      end

      def bytes
        tempfile.size
      end

      private
      def tempfile
        hash.fetch :tempfile
      end
    end

    def coerce(value)
      if value.is_a?(::Hash)
        MultipartImageUpload.new value
      end
    end
  end

  attribute :file, ImageUpload
end
