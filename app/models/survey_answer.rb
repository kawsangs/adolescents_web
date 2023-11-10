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
#  uuid        :string
#  voice       :string
#
class SurveyAnswer < ApplicationRecord
  mount_uploader :voice, AudioUploader

  belongs_to :survey, optional: true
  belongs_to :question
  belongs_to :option, optional: true

  # Callback
  after_create :notify_telegram_groups

  def notify_telegram_groups
    if option&.chat_groups.present?
      survey.notify_groups_async(option.chat_groups)
    end
  end
end
