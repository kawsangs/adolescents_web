# == Schema Information
#
# Table name: questions
#
#  id            :uuid             not null, primary key
#  code          :string
#  name          :text
#  type          :string
#  hint          :string
#  display_order :integer
#  audio         :string
#  topic_id      :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :question do
    name { FFaker::Name.name }
    type { "Questions::SelectOne" }
    hint { "" }
    topic

    factory :question_with_options do
      transient do
        options_count { 2 }
      end

      after(:create) do |question, evaluator|
        create_list(:option, evaluator.options_count, question:)
      end
    end
  end
end
