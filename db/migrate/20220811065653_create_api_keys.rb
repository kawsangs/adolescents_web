class CreateApiKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :api_keys, id: :uuid do |t|
      t.string :name
      t.string :api_key
      t.boolean :actived, default: true
      t.integer :user_id

      t.timestamps
    end
  end
end
