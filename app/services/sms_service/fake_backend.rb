class SmsService
  class FakeBackend
    Sms = Struct.new :number, :text

    attr_reader :messages

    def initialize
      @messages = [ ]
    end

    def deliver(number, msg)
      messages << Sms.new(number, msg)
    end
  end
end
