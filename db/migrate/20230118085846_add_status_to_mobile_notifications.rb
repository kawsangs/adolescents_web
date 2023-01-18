class AddStatusToMobileNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :mobile_notifications, :status, :integer, default: 1
  end
end
