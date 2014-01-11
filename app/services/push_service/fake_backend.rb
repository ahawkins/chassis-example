class PushService
  class FakeBackend
    attr_reader :notifications

    def initialize
      @notifications = [ ]
    end

    def push(notification)
      notifications << notification
    end
  end
end
