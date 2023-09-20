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
require "rails_helper"

RSpec.describe TelegramBot, type: :model do
  it { is_expected.to have_many(:chat_groups).with_foreign_key(:telegram_bot_user_id).with_primary_key(:telegram_bot_user_id) }

  describe "#validates present of token, username" do
    context "enabled is false" do
      let(:telegram_bot) { build(:telegram_bot, enabled: false, token: nil, username: nil) }

      before {
        telegram_bot.valid?
      }

      it "allows blank token" do
        expect(telegram_bot.errors).not_to include("token")
      end

      it "allows blank username" do
        expect(telegram_bot.errors).not_to include("username")
      end
    end

    context "enabled is true" do
      let(:telegram_bot) { build(:telegram_bot, enabled: true, token: nil, username: nil) }

      before {
        telegram_bot.valid?
      }

      it "allows blank token" do
        expect(telegram_bot.errors).to include("token")
      end

      it "allows blank username" do
        expect(telegram_bot.errors).to include("username")
      end
    end
  end

  describe "#before_commit, post_webhook_to_telegram" do
    context "skip_callback is false" do
      let(:telegram_bot) { build(:telegram_bot, skip_callback: false) }

      before {
        allow(telegram_bot).to receive(:post_webhook_to_telegram)
      }

      it "calls post_webhook_to_telegram" do
        telegram_bot.save
        expect(telegram_bot).to have_received(:post_webhook_to_telegram)
      end
    end

    context "skip_callback is true" do
      let(:telegram_bot) { build(:telegram_bot, skip_callback: true) }

      before {
        allow(telegram_bot).to receive(:post_webhook_to_telegram)
      }

      it "calls post_webhook_to_telegram" do
        telegram_bot.save
        expect(telegram_bot).not_to have_received(:post_webhook_to_telegram)
      end
    end
  end
end
