class CreateUserForm < Form
  attribute :name, String
  attribute :auth_token, String
  attribute :device, Hash

  def validate
    errors.add :auth_token, "cannot be blank" if auth_token.nil? || auth_token.strip.empty?

    if !device.is_a?(Hash)
      errors.add :device, "must be a hash"
    else
      uuid = device.fetch 'uuid', nil
      errors.add 'device.uuid', "cannot be blank" if uuid.nil? || uuid.strip.empty?
    end
  end
end
