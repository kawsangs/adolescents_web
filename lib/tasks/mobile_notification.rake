namespace :mobile_notification do
  desc "Migrate status"
  task migrate_status: :environment do
    notifications = MobileNotification.where.not(success_count: nil)
    notifications.update_all(status: :delivered)
  end
end
