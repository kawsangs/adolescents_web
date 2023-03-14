# == Schema Information
#
# Table name: video_authors
#
#  id            :uuid             not null, primary key
#  name          :string
#  videos_count  :integer          default(0)
#  display_order :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class VideoAuthorSerializer < ActiveModel::Serializer
  attributes :id, :name, :videos_count, :display_order, :updated_at, :created_at
end
