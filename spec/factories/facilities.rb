# == Schema Information
#
# Table name: facilities
#
#  id                :uuid             not null, primary key
#  name              :string
#  address           :string
#  tels              :string           default([]), is an Array
#  emails            :string           default([]), is an Array
#  websites          :string           default([]), is an Array
#  facebook_pages    :string           default([]), is an Array
#  telegram_username :string
#  description       :text
#  latitude          :float
#  longitude         :float
#  facility_batch_id :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  province_id       :string
#  district_id       :string
#  commune_id        :string
#  street            :string
#  house_number      :string
#  deleted_at        :datetime
#
FactoryBot.define do
  factory :facility do
    name    { FFaker::Name.name }
    tels    { [FFaker::PhoneNumber.phone_number] }
    address { FFaker::Address.street_address }
    emails  { [FFaker::Internet.email] }
    websites  { [FFaker::Internet.http_url] }
    facebook_pages  { [FFaker::Internet.http_url] }
    telegram_username { "abc" }
    description { FFaker::Book.description }
    latitude  { FFaker::Geolocation.lat }
    longitude { FFaker::Geolocation.lng }
  end
end
