class GroupForm < Form
  attribute :name, String
  attribute :phone_numbers, Array

  validates :name, presence: true
end
