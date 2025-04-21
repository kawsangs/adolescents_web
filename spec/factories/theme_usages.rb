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
FactoryBot.define do
  factory :theme_usage do
    app_user
    theme
    applied_at { Time.current }
  end
end
