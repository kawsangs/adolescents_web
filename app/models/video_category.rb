# == Schema Information
#
# Table name: video_categories
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class VideoCategory < ApplicationRecord
  has_many :videos
end
