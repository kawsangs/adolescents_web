# == Schema Information
#
# Table name: visitors
#
#  id          :uuid             not null, primary key
#  device_id   :string
#  page_id     :uuid
#  platform_id :uuid
#  visit_date  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :visitor do
  end
end
