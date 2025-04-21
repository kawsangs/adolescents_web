class CreateThemeUsages < ActiveRecord::Migration[7.0]
  def change
    create_table :theme_usages, id: :uuid do |t|
      t.uuid :app_user_id, null: false
      t.uuid :theme_id, null: false
      t.datetime :applied_at, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.timestamps
    end
  end
end
