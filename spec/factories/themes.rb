# == Schema Information
#
# Table name: themes
#
#  id                   :uuid             not null, primary key
#  name                 :string
#  status               :integer          default("draft")
#  default              :boolean          default(FALSE)
#  primary_color        :string
#  secondary_color      :string
#  primary_text_color   :string
#  secondary_text_color :string
#  published_at         :datetime
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
FactoryBot.define do
  factory :theme do
    name { FFaker::Name.name[0..14] }
    primary_color { "#000" }
    secondary_color { "#fff" }
    primary_text_color { "#000" }
    secondary_text_color { "#fff" }
    status  { :draft }
    default { false }
    updated_at { Time.now }

    trait :published do
      status { "published" }
      published_at { Time.now }
    end

    trait :default do
      default { true }
    end

    trait :with_assets do
      after(:create) do |theme|
        create_list(:asset, 2, theme:) # Assumes Asset model exists
      end
    end
  end
end
