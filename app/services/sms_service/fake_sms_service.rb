class FakeSmsService
  Sms = Struct.new :number, :text

  attr_reader :messages

  def initialize
    @messages = [ ]
  end

  def deliver(number, msg)
    messages << Sms.new(number, msg)
  end

  def clear
    messages.clear
  end
end

SmsService.register :fake, FakeSmsService.new
