class Characteristic < ApplicationRecord
  # Validation
  validates :name, presence: true, uniqueness: true

  has_many :app_user_characteristics, dependent: :destroy
  has_many :app_users, through: :app_user_characteristics
end
