# == Schema Information
#
# Table name: videos
#
#  id              :uuid             not null, primary key
#  name            :string
#  description     :text
#  url             :string
#  display_order   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  video_batch_id  :uuid
#  video_author_id :uuid
#
class VideoSerializer < ActiveModel::Serializer
  attributes :id, :name, :url, :display_order, :updated_at, :tag_list

  belongs_to :video_author
end
