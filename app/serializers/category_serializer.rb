# == Schema Information
#
# Table name: categories
#
#  id             :uuid             not null, primary key
#  code           :string
#  name           :string
#  image          :string
#  audio          :string
#  description    :text
#  parent_id      :uuid
#  lft            :integer          not null
#  rgt            :integer          not null
#  depth          :integer          default(0), not null
#  children_count :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  deleted_at     :datetime
#
class CategorySerializer < ActiveModel::Serializer
  attributes :id, :code, :name, :image_url, :audio_url,
             :description, :parent_id, :parent_code, :level,
             :lft, :rgt, :tag_list

  has_many :content_sources
  has_many :children

  class ContentSourceSerializer < ActiveModel::Serializer
    attributes :name, :url
  end
end
