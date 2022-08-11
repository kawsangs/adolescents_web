# == Schema Information
#
# Table name: platforms
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Platform < ApplicationRecord
  has_many :visitors
end
