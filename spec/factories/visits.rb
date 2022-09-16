# == Schema Information
#
# Table name: visits
#
#  id          :uuid             not null, primary key
#  page_id     :uuid
#  platform_id :uuid
#  visit_date  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  app_user_id :uuid
#  facility_id :uuid
#
FactoryBot.define do
  factory :visit do
    visit_date { DateTime.yesterday }
    page
    platform
    app_user
  end
end
