class DeviceForm < Form
  attribute :uuid, String
  attribute :push_token, String

  validates :uuid, presence: true
end
