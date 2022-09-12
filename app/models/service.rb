# == Schema Information
#
# Table name: services
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Service < ApplicationRecord
  # Association
  has_many :facility_services
  has_many :facilities, through: :facility_services

  # Validation
  validates :name, presence: true
end
