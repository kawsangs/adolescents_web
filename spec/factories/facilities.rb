# == Schema Information
#
# Table name: facilities
#
#  id                :uuid             not null, primary key
#  name              :string
#  address           :string
#  emails            :string           default([]), is an Array
#  websites          :string           default([]), is an Array
#  facebook_pages    :string           default([]), is an Array
#  telegram_username :string
#  description       :text
#  latitude          :float
#  longitude         :float
#  facility_batch_id :uuid
#  service_id        :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :facility do
  end
end
