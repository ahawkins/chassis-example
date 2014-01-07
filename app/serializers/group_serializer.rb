class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at, :created_at

  def id
    object.id.to_s
  end
end
