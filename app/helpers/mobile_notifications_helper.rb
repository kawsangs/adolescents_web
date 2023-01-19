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
end
