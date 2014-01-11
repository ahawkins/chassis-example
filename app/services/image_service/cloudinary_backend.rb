require 'uri'

class ImageService
  class CloudinaryBackend
    attr_reader :cloudinary_uri

    class CloudinaryImage
      def initialize(json)
        @json = json
      end

      def full_size_url
        json.fetch 'secure_url'
      end

      def thumbnail_url
        eager = json.fetch('eager').first
        eager.fetch 'secure_url'
      end

      def id
        json.fetch 'public_id'
      end

      def width
        json.fetch 'width'
      end

      def height
        json.fetch 'height'
      end

      def bytes
        json.fetch 'bytes'
      end

      private
      def json
        @json
      end
    end

    def initialize(cloudinary_url)
      @cloudinary_uri = URI(cloudinary_url)
      @store = [ ]
    end

    def store(picture)
      @store << picture
    end

    def empty?
      @store.empty?
    end

    def delete(id)
      @store.delete_if do |picture|
        picture.id == id
      end
    end

    def upload(file)
      http = Faraday.new url: 'https://api.cloudinary.com' do |conn|
        conn.request :multipart
        conn.request :url_encoded

        conn.adapter :net_http
      end

      timestamp = Time.now.to_i

      params = {
        file: Faraday::UploadIO.new(file.path, file.content_type),
        api_key: api_key,
        timestamp: timestamp,
        eager: 'w_50,h_50,c_scale'
      }

      params[:signature] = sign params

      response = http.post "/v1_1/#{cloud_name}/image/upload", params

      CloudinaryImage.new JSON.parse(response.body)
    end

    private
    # http://cloudinary.com/documentation/upload_images#request_authentication
    def sign(params)
      signed_params = params.slice :callback, :eager, :format, :public_id, :tags, :timestamp, :transformation, :type
      signed_values = signed_params.sort do |kva, kvb|
        kva.first.to_s <=> kvb.first.to_s
      end.map do |key, value|
        "#{key}=#{value}"
      end.join('&')

      Digest::SHA1.hexdigest "#{signed_values}#{api_secret}"
    end

    def api_key
      cloudinary_uri.user
    end

    def api_secret
      cloudinary_uri.password
    end

    def cloud_name
      cloudinary_uri.host
    end
  end
end
