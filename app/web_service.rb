class WebService < Sinatra::Base
  use Chassis::Rack::Ping
  use Chassis::Rack::Bouncer
  use Rack::BounceFavicon

  use Chassis::Rack::Instrumentation
  use Manifold::Middleware
  use Rack::Deflater

  use Rack::PostBodyContentTypeParser
end
