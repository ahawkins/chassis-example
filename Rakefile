require 'bundler/setup'
require 'rake/testtask'

desc "Run tests"
Rake::TestTask.new :test do |t|
  t.test_files = Rake::FileList['test/**/*_test.rb']
end

task default: :test

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
