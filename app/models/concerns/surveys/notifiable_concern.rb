module Surveys::NotifiableConcern
  extend ActiveSupport::Concern

  included do
    def notify_groups_async(chat_groups)
      chat_groups.each do |chat_group|
        TelegramNotificationJob.perform_async(id, chat_group.id)
      end
    end

    def notify(chat_group)
      ::TelegramBot.client_send_message(chat_group.chat_id, message)
    rescue ::Telegram::Bot::Forbidden => e
      chat_group.update(active: false, reason: e)
    end

    def message
      sms = app_user.profile_html + "\n\n"
      sms += "ការស្ទង់មតិ៖ <code>#{topic.name}</code>" + "\n"
      sms + survey_answer_list
    end

    private
      def survey_answer_list
        list = []

        topic.questions.each do |question|
          answer = survey_answers.select { |ans| ans.question_id == question.id }.first

          list.push("សំនួរ៖ #{question.name}\nចម្លើយ៖ <b>#{answer.try(:value)}</b>") if answer.present?
        end

        list.join("\n\n")
      end
  end
end
