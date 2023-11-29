# == Schema Information
#
# Table name: reasons
#
#  id         :uuid             not null, primary key
#  code       :string
#  name_km    :string
#  name_en    :string
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :reason do
    code { SecureRandom.uuid[0..5] }
    name_km { FFaker::Name.name }
    name_en { FFaker::Name.name }
  end
end
