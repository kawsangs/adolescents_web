class CreateAppUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :app_users, id: :uuid do |t|
      t.string  :gender
      t.integer :age
      t.string  :province_id
      t.datetime :registered_at
      t.string :device_id

      t.timestamps
    end
  end
end
