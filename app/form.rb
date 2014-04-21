class Form
  include Chassis.form
  include ActiveModel::Validations

  def validate!
    raise ValidationError, errors if !valid?
  end
end
