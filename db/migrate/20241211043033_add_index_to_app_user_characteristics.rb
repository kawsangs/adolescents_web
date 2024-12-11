class AddIndexToAppUserCharacteristics < ActiveRecord::Migration[7.0]
  def change
    add_index :app_user_characteristics, [:app_user_id, :characteristic_id], name: "index_app_user_characteristics_on_app_user_id_and_char_id", if_not_exists: true
  end
end
