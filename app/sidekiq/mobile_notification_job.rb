class MobileNotificationJob
  include Sidekiq::Job

  def perform(notification_id)
    @notification = MobileNotification.find_by(id: notification_id)

    mobile_tokens = MobileToken.filter(platform: @notification.platform)
    res = PushNotificationService.new.notify(mobile_tokens, @notification)

    @notification.update_columns(
      success_count: res[:success_count],
      failure_count: res[:failure_count],
      status: :delivered
    )
  end
end
