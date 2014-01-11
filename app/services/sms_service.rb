class SmsService
  cattr_accessor :backend

  DeliveryError = Class.new StandardError

  class NullBackend
    def deliver(number, message)

    end
  end

  class << self
    def deliver(number, message)
      backend.deliver number, message
    end
  end
end

require_relative 'sms_service/twilio_backend'
require_relative 'sms_service/fake_backend'
