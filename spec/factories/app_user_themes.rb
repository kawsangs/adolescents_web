# == Schema Information
#
# Table name: app_user_themes
#
#  id          :bigint           not null, primary key
#  app_user_id :uuid
#  theme_id    :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :app_user_theme do
    
  end
end
