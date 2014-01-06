ENV['RACK_ENV'] = 'test'

root = File.expand_path '../../', __FILE__
require "#{root}/app"

require 'minitest/autorun'

require 'rack/test'

require 'sidekiq/testing'
Sidekiq::Testing.fake!

class BacktraceFilter
  def filter(bt)
    return ["No backtrace"] unless bt

    return bt.dup if $DEBUG

    bt.select { |line| line.include? root }
  end

  def root
    File.expand_path("../../", __FILE__)
  end
end

MiniTest.backtrace_filter = BacktraceFilter.new
