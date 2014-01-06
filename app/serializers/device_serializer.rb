class DeviceSerializer < ActiveModel::Serializer
  attributes :uuid, :push_token
end
