# == Schema Information
#
# Table name: working_days
#
#  id          :uuid             not null, primary key
#  facility_id :uuid
#  day         :integer          default("sunday")
#  open        :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :working_day do
  end
end
