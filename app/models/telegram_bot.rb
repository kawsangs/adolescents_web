# == Schema Information
#
# Table name: telegram_bots
#
#  id                   :uuid             not null, primary key
#  token                :string
#  username             :string
#  telegram_bot_user_id :string
#  enabled              :boolean          default(FALSE)
#  active               :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class TelegramBot < ApplicationRecord
  attr_accessor :skip_callback

  # Association
  has_many :chat_groups, foreign_key: :telegram_bot_user_id, primary_key: :telegram_bot_user_id

  # Validation
  validates :token, :username, presence: true, if: :enabled?

  # Callback
  before_create :post_webhook_to_telegram, unless: :skip_callback
  before_update :post_webhook_to_telegram, unless: :skip_callback

  def post_webhook_to_telegram
    bot = Telegram::Bot::Client.new(token:, username:)

    begin
      request = bot.set_webhook(url: ENV["TELEGRAM_CALLBACK_URL"])

      set_status_active_and_user_id(request)
    rescue
      self.active = false
    end
  end

  def self.instance
    self.first || self.new
  end

  def self.client_send_message(chat_id, message)
    ::Telegram::Bot::Client.new(instance.token)
                           .send_message(chat_id:, text: message, parse_mode: :HTML)
  end

  private
    def set_status_active_and_user_id(request)
      self.active = request["ok"]
      self.telegram_bot_user_id = token.to_s.split(":").first
    end
end
