class CreateThemeSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :theme_settings, id: :uuid do |t|
      t.string :key
      t.string :value
      t.uuid   :theme_id
      t.timestamps
    end
  end
end
