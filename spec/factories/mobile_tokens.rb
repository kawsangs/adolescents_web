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
#
FactoryBot.define do
  factory :mobile_token do
    token { "abcd" }
    device_id { "abc_#{rand(1..10)}" }
    device_type { %w(mobile tablet).sample }
    app_version { "1.0.1" }
  end
end
