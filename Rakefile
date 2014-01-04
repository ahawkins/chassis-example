require 'bundler/setup'
require 'rake/testtask'

desc "Run tests"
Rake::TestTask.new :test do |t|
  t.test_files = Rake::FileList['test/**/*_test.rb']
end

task default: :test
