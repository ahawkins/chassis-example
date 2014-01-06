class UserTokenForm < Form
  attribute :phone_number, String

  validates :phone_number, presence: true, format: {
    with: /\A\+\d+\z/,
    message: 'must be international format (+xxxxxxxxxx)'
  }
end
