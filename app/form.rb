class Form < Chassis::Form
  include ActiveModel::Validations

  def validate!
    raise ValidationError, errors if !valid?
  end
end
