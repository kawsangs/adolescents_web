class AddPlatformToMobileNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :mobile_notifications, :platform, :integer
  end
end
