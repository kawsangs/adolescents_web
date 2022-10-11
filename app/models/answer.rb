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
class Answer < ApplicationRecord
  belongs_to :quiz, optional: true
  belongs_to :question
  belongs_to :option
end
