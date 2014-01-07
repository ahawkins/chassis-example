class GroupForm < Form
  attribute :name, String
  attribute :phone_numbers, Array

  validates :name, presence: true

  validate do |form|
    form.phone_numbers.each do |phone_number|
      if phone_number !~ App.phone_number_regex
        errors.add :phone_numbers, "#{phone_number} is not in international format (+xxxxxxxxxx)"
      end
    end
  end
end
