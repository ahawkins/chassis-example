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

    class ImageFileUpload
      attr_reader :file

      def initialize(file)
        @file = file
      end

      def bytes
        file.size
      end
    end

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
