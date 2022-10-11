# == Schema Information
#
# Table name: quizzes
#
#  id          :uuid             not null, primary key
#  app_user_id :uuid
#  topic_id    :uuid
#  quizzed_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Quiz < ApplicationRecord
  belongs_to :topic
  belongs_to :app_user

  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers, allow_destroy: true
end
