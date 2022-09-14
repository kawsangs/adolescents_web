class CreateMobileNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :mobile_notifications do |t|
      t.string :title
      t.text   :body
      t.integer :success_count
      t.integer :failure_count
      t.integer :creator_id
      t.string :app_versions, array: true, default: []

      t.timestamps
    end
  end
end
