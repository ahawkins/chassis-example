class SmsService
  cattr_accessor :backend

  DeliveryError = Class.new StandardError

  class Twilio
    attr_reader :from_number, :account_sid

    class ErrorHandler < ::Faraday::Response::Middleware
      def on_complete(env)
        status = env.fetch :status
        return if status == 201

        json = JSON.parse(env.fetch(:body))

        raise DeliveryError, "#{status} - #{json.fetch('message')}"
      end
    end

    def initialize(account_sid, auth_token, number)
      @connection = Faraday.new 'https://api.twilio.com' do |conn|
        conn.request :url_encoded
        conn.request :basic_auth, account_sid, auth_token

        conn.use ErrorHandler
        conn.adapter :net_http
      end

      @account_sid = account_sid
      @from_number = number
    end

    def deliver(number, message)
      connection.post "/2010-04-01/Accounts/#{account_sid}/SMS/Messages.json", {
        From: from_number,
        To: number,
        Body: message
      }
      true
    rescue Faraday::Error::TimeoutError => ex
      raise DeliveryError, "request timed out"
    end

    private
    def connection
      @connection
    end
  end

  class << self
    def deliver(number, message)
      backend.deliver number, message
    end
  end
end
