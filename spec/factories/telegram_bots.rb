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
FactoryBot.define do
  factory :telegram_bot do
    username { FFaker::Name.name }
    token    { "#{format('%010d', rand(9_000_000_000))}:SecureRandom.uuid" }
    telegram_bot_user_id { token.to_s.split(":").first }
    skip_callback { true }
  end
end
