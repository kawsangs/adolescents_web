# == Schema Information
#
# Table name: mobile_tokens
#
#  id          :uuid             not null, primary key
#  device_id   :string
#  device_type :string
#  token       :string
#  app_version :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  platform    :integer          default("android")
#  device_os   :string
#
require "rails_helper"

RSpec.describe MobileToken, type: :model do
  it { is_expected.to have_many(:mobile_notification_logs) }

  it { is_expected.to validate_presence_of(:token) }
  it { is_expected.to validate_presence_of(:device_id) }
  it { is_expected.to validate_presence_of(:device_type) }
  it { is_expected.to validate_presence_of(:app_version) }
end
