# == Schema Information
#
# Table name: characteristics
#
#  id         :uuid             not null, primary key
#  code       :string
#  name_en    :string
#  name_km    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Characteristic < ApplicationRecord
  # Validation
  validates :name_en, presence: true, uniqueness: true
  validates :name_km, presence: true, uniqueness: true

  has_many :app_user_characteristics, dependent: :destroy
  has_many :app_users, through: :app_user_characteristics
end
