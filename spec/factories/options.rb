# == Schema Information
#
# Table name: options
#
#  id          :uuid             not null, primary key
#  question_id :uuid
#  name        :string
#  message     :text
#  move_next   :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  value       :string
#
FactoryBot.define do
  factory :option do
    name { FFaker::Name.name }
    move_next { [true, false].sample }
    message { FFaker::Name.name unless move_next }
    question
  end
end
