class AuthToken
  include Chassis::Persistence

  attr_accessor :phone_number, :code

  def destroy
    repo.delete self
  end
end
