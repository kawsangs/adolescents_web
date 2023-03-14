class AddDetailToMobileNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :mobile_notifications, :detail, :json, default: {}
  end
end
