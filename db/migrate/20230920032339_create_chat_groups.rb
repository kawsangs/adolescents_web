class CreateChatGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_groups, id: :uuid do |t|
      t.string   :title
      t.string   :chat_id
      t.string   :chat_type, default: "group"
      t.boolean  :active, default: true
      t.text     :reason
      t.string   :telegram_bot_user_id

      t.timestamps
    end
  end
end
