class PictureSerializer < ActiveModel::Serializer
  attribute :id

  attribute :full_size_url
  attribute :thumbnail_url

  attribute :height
  attribute :width

  attribute :bytes

  attribute :date

  has_one :user, embed: :objects

  def id
    object.id.to_s
  end
end
