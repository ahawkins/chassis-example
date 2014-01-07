class PushService
  cattr_accessor :backend

  class << self
    def push(notification)
      backend.push notification
    end
  end
end
