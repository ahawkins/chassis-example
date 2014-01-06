class SmsService
  cattr_accessor :backend

  class << self
    def deliver(number, message)
      backend.deliver number, message
    end
  end
end
