class CreateAppUserCharacteristics < ActiveRecord::Migration[7.0]
  def change
    create_table :app_user_characteristics, id: :uuid do |t|
      t.uuid :app_user_id
      t.uuid :characteristic_id

      t.timestamps
    end
  end
end
