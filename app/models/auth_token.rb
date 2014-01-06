class AuthToken
  include Persistance
  include Chassis::HashInitializer

  attr_accessor :phone_number, :code
end
