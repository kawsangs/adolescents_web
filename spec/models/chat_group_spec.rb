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
require "rails_helper"

RSpec.describe ChatGroup, type: :model do
  it { is_expected.to belong_to(:telegram_bot).with_foreign_key(:telegram_bot_user_id).with_primary_key(:telegram_bot_user_id) }
end
