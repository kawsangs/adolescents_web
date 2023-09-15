# == Schema Information
#
# Table name: contact_directories
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :contact_directory do
    name { FFaker::Name.name }

    trait :with_contacts do
      transient do
        count { 1 }
      end

      after(:create) do |directory, evaluator|
        create_list(:contact, evaluator.count, contact_directory: directory)
      end
    end
  end
end
