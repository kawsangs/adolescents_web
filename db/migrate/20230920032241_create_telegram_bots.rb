class CreateTelegramBots < ActiveRecord::Migration[7.0]
  def change
    create_table :telegram_bots, id: :uuid do |t|
      t.string  :token
      t.string  :username
      t.string  :telegram_bot_user_id
      t.boolean :enabled, default: false
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
