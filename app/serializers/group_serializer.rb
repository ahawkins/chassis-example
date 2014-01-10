class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at, :created_at
  attribute :total_pictures

  has_many :users, embed: :objects
  has_many :pictures, embed: :objects
  has_one :cover, embed: :object

  def id
    object.id.to_s
  end
end
