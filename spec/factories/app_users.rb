# == Schema Information
#
# Table name: app_users
#
#  id               :uuid             not null, primary key
#  gender           :string
#  age              :integer
#  province_id      :string
#  registered_at    :datetime
#  device_id        :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  last_accessed_at :datetime
#  platform         :integer          default("android")
#  occupation       :integer          default("n_a")
#  education_level  :integer          default("n_a")
#  uuid             :string
#  deleted_at       :datetime
#
FactoryBot.define do
  factory :app_user do
    gender { AppUser::GENDERS.sample }
    occupation { AppUser.occupations.keys.sample }
    education_level { AppUser.education_levels.keys.sample }
    age    { rand(10..19) }
    province_id { format("%02d", rand(1..25)) }
    device_id { "abc_#{rand(1..10)}" }
    registered_at { Time.zone.now }
    uuid { SecureRandom.uuid }

    trait :anonymous do
      gender { nil }
      age { -1 }
      province_id  { nil }
      registered_at { DateTime.yesterday }
    end
  end
end
