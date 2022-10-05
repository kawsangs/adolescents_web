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
#
class Option < ApplicationRecord
  # Validation
  validates :name, presence: true, uniqueness: { scope: [:question_id] }
end
