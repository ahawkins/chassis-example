require 'fabrication'
# Mimic ActiveRecord interface so Fabrication works
# as intended

module Chassis
  module Persistence
    def save!
      save
    end
  end
end
