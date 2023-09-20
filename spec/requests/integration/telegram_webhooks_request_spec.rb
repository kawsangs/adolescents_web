# frozen_string_literal: true

require "rails_helper"
require "telegram/bot/rspec/integration/rails"

RSpec.describe Api::Integration::TelegramWebhooksController, telegram_bot: :rails do
  let!(:bot) { create(:telegram_bot, telegram_bot_user_id: "1234567890") }
  subject { described_class.new }

  describe "#my_chat_member" do
    context "create new or add to telegram group" do
      let(:message) {
        {
          "chat"=> { "id"=>-920000001, "title"=>"wow_group", "type"=>"group", "all_members_are_administrators"=>true },
          "from"=> { "id"=>123456789, "is_bot"=>false, "first_name"=>"Sokly", "last_name"=>"Heng" },
          "date"=>1692159669,
          "old_chat_member"=>{ "user"=>{ "id"=>1234567890, "is_bot"=>true, "first_name"=>"myjourneys_bot", "username"=>"myjourneys_bot" }, "status"=>"left" },
          "new_chat_member"=>{ "user"=>{ "id"=>1234567890, "is_bot"=>true, "first_name"=>"myjourneys_bot", "username"=>"myjourneys_bot" }, "status"=>"member" }
        }
      }

      it "creates an active chat group" do
        subject.process(:my_chat_member, message)
        group = bot.chat_groups.actives.first

        expect(group).not_to be_nil
        expect(group.title).to eq("wow_group")
      end
    end

    context "group update bot as administrator" do
      let(:message) {
        {
          "chat"=>{ "id"=>-920000001, "title"=>"wow_group", "type"=>"group", "all_members_are_administrators"=>true },
          "from"=>{ "id"=>123456789, "is_bot"=>false, "first_name"=>"Sokly", "last_name"=>"Heng" },
          "date"=>1692159778,
          "old_chat_member"=>{ "user"=>{ "id"=>1234567890, "is_bot"=>true, "first_name"=>"myjourneys_bot", "username"=>"myjourneys_bot" }, "status"=>"member" },
          "new_chat_member"=>{ "user"=>{ "id"=>1234567890, "is_bot"=>true, "first_name"=>"myjourneys_bot", "username"=>"myjourneys_bot" }, "status"=>"administrator", "can_be_edited"=>false, "can_manage_chat"=>true, "can_change_info"=>true, "can_delete_messages"=>true, "can_invite_users"=>true, "can_restrict_members"=>true, "can_pin_messages"=>true, "can_promote_members"=>false, "can_manage_video_chats"=>true, "is_anonymous"=>false, "can_manage_voice_chats"=>true }
        }
      }

      it "ignores the message" do
        subject.process(:my_chat_member, message)

        expect(bot.chat_groups.count).to eq(0)
      end
    end

    context "delete or remove from telegram group" do
      let!(:group) { create(:chat_group, telegram_bot: bot, chat_id: "-920000001") }
      let(:message) {
        {
          "chat"=>{ "id"=>-920000001, "title"=>"wow_group", "type"=>"group", "all_members_are_administrators"=>false },
          "from"=>{ "id"=>123456789, "is_bot"=>false, "first_name"=>"Sokly", "last_name"=>"Heng" },
          "date"=>1692160927,
          "old_chat_member"=>{ "user"=>{ "id"=>1234567890, "is_bot"=>true, "first_name"=>"myjourneys_bot", "username"=>"myjourneys_bot" }, "status"=>"administrator", "can_be_edited"=>false, "can_manage_chat"=>true, "can_change_info"=>true, "can_delete_messages"=>true, "can_invite_users"=>true, "can_restrict_members"=>true, "can_pin_messages"=>true, "can_promote_members"=>false, "can_manage_video_chats"=>true, "is_anonymous"=>false, "can_manage_voice_chats"=>true },
          "new_chat_member"=>{ "user"=>{ "id"=>1234567890, "is_bot"=>true, "first_name"=>"myjourneys_bot", "username"=>"myjourneys_bot" }, "status"=>"left" }
        }
      }

      subject { described_class.new }

      it "update to inactive chat group" do
        subject.process(:my_chat_member, message)

        expect(group.reload.active).to be_falsey
      end
    end
  end

  describe "#message" do
    let!(:group) { create(:chat_group, telegram_bot: bot, chat_id: "-920000001") }

    let(:message) {
      {
        "message_id" => 564,
        "migrate_to_chat_id" => -123,
        "from" => { "id" => 1111, "is_bot" => false, "first_name" => "Sokly", "last_name" => "Heng", "language_code" => "en" },
        "chat" => { "id" => -920000001, "title" => "wow_group", "type" => "group", "all_members_are_administrators" => true }
      }
    }

    it "update the chat_group to super group" do
      subject.process(:message, message)

      expect(group.reload.chat_id).to eq "-123"
      expect(group.reload.chat_type).to eq ChatGroup::TELEGRAM_SUPER_GROUP
    end
  end
end
