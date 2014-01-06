class UserTokenForm < Chassis::Form
  include Validation

  attribute :phone_number, String

  def validate
    if phone_number.nil? || phone_number.empty?
      errors.add :phone_number, "cannot be blank"
    end
  end
end
