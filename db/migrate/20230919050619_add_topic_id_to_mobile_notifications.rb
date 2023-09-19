class AddTopicIdToMobileNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :mobile_notifications, :topic_id, :uuid
  end
end
