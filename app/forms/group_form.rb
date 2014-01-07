class GroupForm < Form
  attribute :name, String

  validates :name, presence: true
end
