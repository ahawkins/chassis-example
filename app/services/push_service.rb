class PushService
  extend Chassis.strategy(:push, :notifications, :clear)
end

require_relative 'push_service/fake_push_service'
