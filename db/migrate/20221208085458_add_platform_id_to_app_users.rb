class AddPlatformIdToAppUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :app_users, :platform, :integer, default: 1
    remove_column :visits, :platform_id
  end
end
