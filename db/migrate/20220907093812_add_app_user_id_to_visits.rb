class AddAppUserIdToVisits < ActiveRecord::Migration[7.0]
  def up
    add_column :visits, :app_user_id, :uuid
    remove_column :visits, :device_id
  end

  def down
    remove_column :visits, :app_user_id
    add_column :visits, :device_id, :string
  end
end
