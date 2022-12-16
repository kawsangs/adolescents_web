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
#
require "rails_helper"

RSpec.describe Facility, type: :model do
  it { is_expected.to belong_to(:facility_batch).optional }
  it { is_expected.to have_many(:working_days).dependent(:destroy) }
  it { is_expected.to have_many(:facility_services) }
  it { is_expected.to have_many(:services).through(:facility_services) }
  it { is_expected.to have_many(:taggings) }
  it { is_expected.to have_many(:tags).through(:taggings) }

  it { is_expected.to validate_presence_of(:name) }
end
