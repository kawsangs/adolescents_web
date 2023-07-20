# == Schema Information
#
# Table name: taggings
#
#  id            :bigint           not null, primary key
#  tag_id        :uuid
#  facility_id   :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  taggable_id   :uuid
#  taggable_type :string
#
class Tagging < ApplicationRecord
  belongs_to :tag, counter_cache: true
  belongs_to :taggable, polymorphic: true
end
