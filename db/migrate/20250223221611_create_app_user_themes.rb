class CreateAppUserThemes < ActiveRecord::Migration[7.0]
  def change
    create_table :app_user_themes do |t|
      t.uuid :app_user_id
      t.uuid :theme_id
      
      t.timestamps
    end
  end
end
