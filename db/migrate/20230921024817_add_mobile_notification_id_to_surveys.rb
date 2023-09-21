class AddMobileNotificationIdToSurveys < ActiveRecord::Migration[7.0]
  def change
    add_column :surveys, :mobile_notification_id, :integer
  end
end
