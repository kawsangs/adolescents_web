# == Schema Information
#
# Table name: taggings
#
#  id          :bigint           not null, primary key
#  tag_id      :uuid
#  facility_id :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Tagging < ApplicationRecord
  belongs_to :tag, counter_cache: true
  belongs_to :facility
end
