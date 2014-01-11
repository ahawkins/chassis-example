$stdout.sync = true
$stderr.sync = true

twilio_account_sid = ENV.fetch 'TWILIO_ACCOUNT_SID'
twilio_auth_token = ENV.fetch 'TWILIO_AUTH_TOKEN'
twilio_number = ENV.fetch 'TWILIO_NUMBER'

SmsService.backend = SmsService::TwilioBackend.new twilio_account_sid, twilio_auth_token, twilio_number
ImageService.backend = ImageService::CloudinaryBackend.new ENV.fetch 'CLOUDINARY_URL'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDISCLOUD_URL'), namespace: 'sidekiq' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDISCLOUD_URL'), namespace: 'sidekiq' }
end

connection_pool = ConnectionPool::Wrapper.new(size: ENV.fetch('PUMA_MAX_THREADS').to_i) do
  Redis::Namespace.new 'repo', redis: Redis.new(url: ENV.fetch('REDISCLOUD_URL'))
end
Chassis::Repo.backend = RedisAdapter.new connection_pool

Chassis::Repo.instance.initialize_storage!
