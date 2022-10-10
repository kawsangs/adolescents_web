# == Schema Information
#
# Table name: answers
#
#  id          :uuid             not null, primary key
#  quiz_id     :uuid
#  question_id :uuid
#  option_id   :uuid
#  value       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :answer do
  end
end
