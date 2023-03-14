module MobileNotificationsHelper
  def status_html(status)
    status_method = ["status", status, "html"].compact.join("_")

    send(status_method) rescue status
  end

  def status_pending_html
    "<span class='badge bg-warning text-dark'>Pending</span>"
  end

  def status_delivered_html
    "<span class='badge bg-success'>Delivered</span>"
  end

  def description(notification)
    return "" if notification.success_count.nil?

    "#{I18n.t('mobile_notification.success')}: #{notification_count(notification, 'success')}, " +
    "#{I18n.t('mobile_notification.failure')}: #{notification_count(notification, 'failure')}"
  rescue
    ""
  end

  def notification_count(notification, detail_action = "success")
    count = notification.send("#{detail_action}_count")
    option = notification.detail[detail_action]

    return "<strong>#{number_with_delimiter(count)}</strong>" if count.zero? || option.blank? || notification.platform.present?

    description_tooltip(I18n.t("mobile_notification.#{detail_action}"), count, option)
  end

  def description_tooltip(label, count, option)
    title = "#{label}: #{number_with_delimiter(count)} <br>(iOs: #{number_with_delimiter(option['ios'])}, Android: #{number_with_delimiter(option['android'])})"

    "<strong data-bs-toggle='tooltip' data-bs-placement='top' data-bs-html='true' title='#{title}'>#{number_with_delimiter(count)}</strong>"
  end
end
