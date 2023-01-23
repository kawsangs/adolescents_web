# == Schema Information
#
# Table name: importing_facilities
#
#  id                :bigint           not null, primary key
#  facility_id       :uuid
#  facility_batch_id :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :importing_facility do
  end
end
