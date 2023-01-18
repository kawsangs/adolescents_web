class CreateMobileNotificationLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :mobile_notification_logs do |t|
      t.integer :mobile_notification_id
      t.uuid    :mobile_token_id
      t.text    :failed_reason

      t.timestamps
    end
  end
end
