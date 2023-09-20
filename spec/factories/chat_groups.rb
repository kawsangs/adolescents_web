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
FactoryBot.define do
  factory :chat_group do
    title { FFaker::Name.name }
    chat_id { format("%09d", rand(900_000_000)) }
    active { true }
    telegram_bot { create(:telegram_bot) }
  end
end
