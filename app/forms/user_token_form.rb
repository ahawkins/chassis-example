class UserTokenForm < Form
  attribute :phone_number, String

  def validate
    if phone_number.nil? || phone_number.empty?
      errors.add :phone_number, "cannot be blank"
      return
    end

    if phone_number !~ /^\+\d+$/
      errors.add :phone_number, "must be international format (+xxxxxxxxxxx)"
    end
  end
end
