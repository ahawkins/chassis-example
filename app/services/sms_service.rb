class SmsService
  DeliveryError = Class.new StandardError

  extend Chassis.strategy(:deliver, :messages, :clear)
end

require_relative 'sms_service/twilio_sms_service'
require_relative 'sms_service/fake_sms_service'
