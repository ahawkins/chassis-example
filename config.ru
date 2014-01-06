root = File.dirname __FILE__
require "#{root}/app"
require 'sidekiq/web'

map "/" do
  run WebService
end

map "/sidekiq" do
  use Rack::Auth::Basic, 'Sidekiq' do |username, password|
    password == ENV.fetch('SIDEKIQ_PASSWORD', 'password')
  end
  run Sidekiq::Web
end
