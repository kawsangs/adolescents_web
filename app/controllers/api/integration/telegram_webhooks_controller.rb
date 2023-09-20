# frozen_string_literal: true

module Api
  module Integration
    class TelegramWebhooksController < Telegram::Bot::UpdatesController
      include Telegram::Bot::UpdatesController::MessageContext

      def my_chat_member(message)
        upsert_chat_group(message) if managing_member?(message)
      end

      def message(message)
        migrate_chat_group(message) if message["migrate_to_chat_id"].present?
      end

      private
        def migrate_chat_group(message)
          group = ChatGroup.find_by(chat_id: message["chat"]["id"].to_s)
          group.update(chat_id: message["migrate_to_chat_id"], chat_type: ChatGroup::TELEGRAM_SUPER_GROUP) if group.present?
        end

        def managing_member?(message)
          ["member", "left"].include? message["new_chat_member"]["status"]
        end

        def upsert_chat_group(message)
          bot = TelegramBot.find_by(telegram_bot_user_id: message["new_chat_member"]["user"]["id"].to_s)
          return if bot.nil?

          group = bot.chat_groups.find_or_initialize_by(chat_id: message["chat"]["id"].to_s)
          group.update(
            title: message["chat"]["title"],
            active: message["new_chat_member"]["status"] == "member",
            chat_type: message["chat"]["type"]
          )
        end
    end
  end
end
