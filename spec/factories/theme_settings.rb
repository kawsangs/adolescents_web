# == Schema Information
#
# Table name: theme_settings
#
#  id         :uuid             not null, primary key
#  key        :string
#  value      :string
#  theme_id   :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :theme_setting do
  end
end
