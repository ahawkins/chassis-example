class FakePushService
  attr_reader :notifications

  def initialize
    @notifications = [ ]
  end

  def push(notification)
    notifications << notification
  end

  def clear
    notifications.clear
  end
end

PushService.register :fake, FakePushService.new
