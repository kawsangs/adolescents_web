class MobileNotificationJob
  include Sidekiq::Job

  def perform(notification_id)
    @notification = MobileNotification.find_by(id: notification_id)

    tokens = MobileToken.filter({ app_versions: @notification.app_versions }).pluck(:token)
    res = PushNotificationService.new.notify(tokens, @notification.build_content)

    @notification.update(
      success_count: res[:success_count],
      failure_count: res[:failure_count]
    )
  end
end
