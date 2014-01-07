class CreateGroup
  attr_reader :form, :current_user

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
      raise Form::ValidationError, errors unless valid?
    end

    def each(&block)
      @numbers.each(&block)
    end
  end

  def initialize(form, current_user)
    @form, @current_user = form, current_user
  end

  def run!
    form.validate!
    PhoneNumbersValidator.new(form.phone_numbers).validate!

    group = Group.new do |group|
      group.name = form.name
      group.admin = current_user

      group.users = form.phone_numbers.map do |number|
        UserRepo.find_by_phone_number! number
      end
    end

    group.users << current_user

    group.save

    group
  end
end
