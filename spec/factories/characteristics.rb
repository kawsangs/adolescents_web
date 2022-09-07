# == Schema Information
#
# Table name: characteristics
#
#  id         :uuid             not null, primary key
#  code       :string
#  name_en    :string
#  name_km    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :characteristic do
    trait :poor do
      code  { "PO" }
      name_en { "Poor Card" }
      name_km { "មានប័ណ្ណក្រីក្រ" }
    end

    trait :minority do
      code  { "MI" }
      name_en { "Minority" }
      name_km { "ជនជាតិដើម" }
    end

    trait :disablity do
      code  { "DI" }
      name_en { "Disablity" }
      name_km { "ជនមានពិការភាព" }
    end
  end
end
