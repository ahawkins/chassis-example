class CreateUserForm < Form
  attribute :name, String
  attribute :auth_token, String
  attribute :device, Hash

  def validate
    errors.add :name, "cannot be blank" if name.blank?
    errors.add :auth_token, "cannot be blank" if auth_token.blank?

    if !device.is_a?(Hash)
      errors.add :device, "must be a hash"
    else
      uuid = device.fetch 'uuid', nil
      errors.add 'device.uuid', "cannot be blank" if uuid.blank?
    end
  end
end
