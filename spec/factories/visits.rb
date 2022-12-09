# == Schema Information
#
# Table name: visits
#
#  id            :uuid             not null, primary key
#  page_id       :uuid
#  visit_date    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  app_user_id   :uuid
#  pageable_id   :uuid
#  pageable_type :integer
#
FactoryBot.define do
  factory :visit do
    visit_date { DateTime.yesterday }
    page
    app_user
  end
end
