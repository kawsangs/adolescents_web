# == Schema Information
#
# Table name: content_sources
#
#  id          :uuid             not null, primary key
#  name        :string
#  url         :string
#  category_id :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ContentSource < ApplicationRecord
  belongs_to :category
end
