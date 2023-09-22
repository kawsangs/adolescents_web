# == Schema Information
#
# Table name: survey_answers
#
#  id          :uuid             not null, primary key
#  survey_id   :uuid
#  question_id :uuid
#  option_id   :uuid
#  value       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :survey_answer do
  end
end
