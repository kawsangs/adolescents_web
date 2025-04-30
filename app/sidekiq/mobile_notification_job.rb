class MobileNotificationJob
  include Sidekiq::Job

  def perform(notification_id)
    @notification = MobileNotification.find_by(id: notification_id)
    return unless @notification

    push_notifications
    update_notification
  end

  private
    def mobile_tokens
      MobileToken.filter(platform: @notification.platform, app_versions: @notification.app_versions).actives
    end

    def push_notifications
      @result = PushNotificationService.new(@notification).notify_all(mobile_tokens)
    end

    def update_notification
      @notification.update_columns(
        success_count: @result[:success_count],
        failure_count: @result[:failure_count],
        status: :delivered,
        detail: @result[:detail]
      )
    end
end
