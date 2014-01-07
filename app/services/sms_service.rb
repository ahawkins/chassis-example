class SmsService
  cattr_accessor :backend

  DeliveryError = Class.new StandardError

  class NullBackend
    def deliver(number, message)

    end
  end

  class Twilio
    attr_reader :from_number, :account_sid

    class SendSms
      include Sidekiq::Worker

      class ErrorHandler < ::Faraday::Response::Middleware
        def on_complete(env)
          status = env.fetch :status
          return if status == 201

          json = JSON.parse(env.fetch(:body))

          raise DeliveryError, "#{status} - #{json.fetch('message')}"
        end
      end

      def perform(account_sid, auth_token, from_number, to_number, message)
        connection = Faraday.new 'https://api.twilio.com' do |conn|
          conn.request :url_encoded
          conn.request :basic_auth, account_sid, auth_token

          conn.use ErrorHandler
          conn.adapter :net_http
        end

        connection.post "/2010-04-01/Accounts/#{account_sid}/SMS/Messages.json", {
          From: from_number,
          To: to_number,
          Body: message
        }
        true
      rescue Faraday::Error::TimeoutError => ex
        raise DeliveryError, "request timed out"
      end
    end

    attr_reader :account_sid, :auth_token, :number

    def initialize(account_sid, auth_token, number)
      @account_sid = account_sid
      @auth_token = auth_token
      @from_number = number
    end

    def deliver(number, message)
      SendSms.perform_async account_sid, auth_token, from_number, number, message
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
