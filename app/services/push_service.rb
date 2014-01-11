class PushService
  cattr_accessor :backend

  class NullBackend
    def push(notification)

    end
  end

  class << self
    def push(notification)
      backend.push notification
    end
  end
end

require_relative 'push_service/fake_backend'
