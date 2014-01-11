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
      @existing = { }
      @deleted = { }
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

      image = CloudinaryImage.new(JSON.parse(response.body))

      image
    end

    def exists?(id)
      return false if deleted[id]

      http = Faraday.new url: 'http://res.cloudinary.com' do |conn|
        conn.adapter :net_http
      end
      response = http.get("/#{cloud_name}/image/upload/#{id}.jpg").status.to_i == 200
    end

    def delete(id)
      http = Faraday.new url: 'https://api.cloudinary.com' do |conn|
        conn.request :url_encoded

        conn.adapter :net_http
      end

      timestamp = Time.now.to_i

      params = {
        public_id: id,
        api_key: api_key,
        timestamp: timestamp,
      }

      params[:signature] = sign params

      http.delete "/v1_1/#{cloud_name}/image/destroy", params

      deleted[id] = true
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

    def existing
      @existing
    end

    def deleted
      @deleted
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
