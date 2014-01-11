require 'bundler/setup'
require 'rake/testtask'

namespace :test do
  desc "Run tests in quick mode"
  Rake::TestTask.new :all do |t|
    t.test_files = Rake::FileList['test/**/*_test.rb']
  end

  desc "Run tests against real services"
  task ci: ['ci_env', 'all']

  task :ci_env do
    ENV['CI'] = 'true'
  end
end

task default: 'test:all'

task :environment do
  root = File.dirname __FILE__
  require "#{root}/app"
end

namespace :sidekiq do
  desc "Empty all sidekiq jobs"
  task clear: :environment do
    Sidekiq::Queue.all.each do |q|
      Sidekiq.redis { |r| r.del "queue:#{q}" }
    end
  end
end

namespace :repo do
  desc "Empty all sidekiq jobs"
  task clear: :environment do
    Chassis::Repo.instance.clear
    ImageService.clear
  end
end
