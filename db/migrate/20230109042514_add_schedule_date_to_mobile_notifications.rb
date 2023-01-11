class AddScheduleDateToMobileNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :mobile_notifications, :schedule_date, :datetime
    add_column :mobile_notifications, :mobile_notification_batch_id, :integer
    add_column :mobile_notifications, :job_id, :string
  end
end
