class VideoAuthorSerializer < ActiveModel::Serializer
  attributes :id, :name, :videos_count, :display_order, :updated_at, :created_at
end
