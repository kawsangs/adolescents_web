# == Schema Information
#
# Table name: theme_usages
#
#  id          :uuid             not null, primary key
#  app_user_id :uuid             not null
#  theme_id    :uuid             not null
#  applied_at  :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ThemeUsage < ApplicationRecord
  belongs_to :app_user
  belongs_to :theme

  # Validation
  validates :applied_at, presence: true
end
