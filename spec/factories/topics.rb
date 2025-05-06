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
#  type         :string
#  description  :text
#
FactoryBot.define do
  factory :topic do
    name_km { FFaker::Name.name }
    name_en { FFaker::Name.name }
    type    { Topics::FaqForm }

    trait :published do
      published_at { Time.current }
    end
  end

  factory :survey_form, class: "Topics::SurveyForm" do
    name_km { FFaker::Name.name }
    name_en { FFaker::Name.name }

    trait :published do
      published_at { Time.current }
    end
  end
end
