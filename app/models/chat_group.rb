# == Schema Information
#
# Table name: chat_groups
#
#  id                   :uuid             not null, primary key
#  title                :string
#  chat_id              :string
#  chat_type            :string           default("group")
#  active               :boolean          default(TRUE)
#  reason               :text
#  telegram_bot_user_id :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class ChatGroup < ApplicationRecord
  # Association
  belongs_to :telegram_bot, foreign_key: :telegram_bot_user_id, primary_key: :telegram_bot_user_id
  has_many :options_chat_groups
  has_many :options, through: :options_chat_groups

  # Constant
  TELEGRAM_CHAT_TYPES = %w[group supergroup]
  TELEGRAM_SUPER_GROUP = "supergroup"
  TELEGRAM_GROUP = "group"

  # Scope
  scope :actives, -> { where(active: true) }
end
