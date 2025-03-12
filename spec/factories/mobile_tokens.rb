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
#  active      :boolean          default(TRUE)
#
FactoryBot.define do
  factory :mobile_token do
    token       { SecureRandom.hex(10) }
    device_id   { SecureRandom.hex(8) }
    device_type { %w(mobile tablet).sample }
    app_version { "1.0.1" }
    platform    { "android" }

    trait :ios do
      platform { "ios" }
    end
  end
end
