# == Schema Information
#
# Table name: facilities
#
#  id                :uuid             not null, primary key
#  name              :string
#  tels              :string           default([]), is an Array
#  address           :string
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
#
require "rails_helper"

RSpec.describe Facility, type: :model do
  it { is_expected.to belong_to(:facility_batch).optional }
  it { is_expected.to have_many(:working_days).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
end
