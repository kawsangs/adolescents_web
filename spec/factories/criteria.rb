# == Schema Information
#
# Table name: criteria
#
#  id             :uuid             not null, primary key
#  question_id    :uuid
#  question_code  :string
#  operator       :string
#  response_value :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :criteria do
  end
end
