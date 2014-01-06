class CreateUserForm < Form
  attribute :name, String
  attribute :auth_token, String
  attribute :device, Hash

  validates :name, :auth_token, :device, presence: true

  validate do |form|
    next unless form.device

    uuid = form.device.fetch 'uuid', nil
    errors.add :device, "uuid cannot be blank" if uuid.blank?
  end
end
