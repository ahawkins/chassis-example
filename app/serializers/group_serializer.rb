class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at, :created_at

  has_many :users, embed: :objects

  def id
    object.id.to_s
  end
end
