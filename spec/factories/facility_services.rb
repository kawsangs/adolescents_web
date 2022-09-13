# == Schema Information
#
# Table name: facility_services
#
#  id          :uuid             not null, primary key
#  facility_id :uuid
#  service_id  :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :facility_service do
  end
end
