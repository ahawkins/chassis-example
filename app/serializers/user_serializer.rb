class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :token

  has_one :device

  def include_token?
    scope == object
  end

  def id
    object.id.to_s
  end
end
