class CreateMobileTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :mobile_tokens, id: :uuid do |t|
      t.string :device_id
      t.integer :device_type
      t.string :token
      t.string :app_version

      t.timestamps
    end
  end
end
