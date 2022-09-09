# == Schema Information
#
# Table name: app_users
#
#  id            :uuid             not null, primary key
#  gender        :string
#  age           :integer
#  province_id   :string
#  registered_at :datetime
#  device_id     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :app_user do
    trait :anonymous do
      gender { nil }
      age { -1 }
      province_id  { nil }
      registered_at { DateTime.yesterday }
      device_id { "123" }
    end
  end
end
