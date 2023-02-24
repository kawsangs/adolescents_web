# == Schema Information
#
# Table name: topics
#
#  id           :uuid             not null, primary key
#  name_km      :string
#  version      :integer          default(0)
#  published_at :datetime
#  audio        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  code         :string
#  name_en      :string
#
FactoryBot.define do
  factory :topic do
    name_km { FFaker::Name.name }
    name_en { FFaker::Name.name }

    trait :published do
      published_at { Time.now }
    end
  end
end
