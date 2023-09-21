# frozen_string_literal: true

class TelegramNotificationJob
  include Sidekiq::Job

  def perform(survey_id, chat_group_id)
    survey = Survey.find(survey_id)
    chat_group = ChatGroup.find(chat_group_id)

    survey.notify(chat_group)
  end
end
