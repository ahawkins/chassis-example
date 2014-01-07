class UserTokenForm < Form
  attribute :phone_number, String

  validates :phone_number, presence: true, format: {
    with: App.phone_number_regex,
    message: 'must be international format (+xxxxxxxxxx)'
  }
end
