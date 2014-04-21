require 'sidekiq/testing'
Sidekiq::Testing.fake!
Sidekiq.logger = NullLogger.new
