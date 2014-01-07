class PhoneNumbersValidator
  include ActiveModel::Validations
  include Enumerable

  validate do |phone_numbers|
    phone_numbers.each do |number|
      begin
        UserRepo.find_by_phone_number! number
      rescue UserRepo::UnknownPhoneNumber => ex
        phone_numbers.errors.add :phone_numbers, ex.message
      end
    end
  end

  def initialize(numbers)
    @numbers = numbers
  end

  def validate!
    raise ValidationError, errors unless valid?
  end

  def each(&block)
    @numbers.each(&block)
  end
end
