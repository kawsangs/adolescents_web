module TopicsHelper
  def form_status_html(form)
    status_method = ["form_status", form.status, "html"].compact.join("_")

    send(status_method, form) rescue form.status
  end

  def form_status_draft_html(form)
    title = "#{I18n.t('mobile_notification.drafted_at')}: #{I18n.l(form.updated_at)}"

    "<span class='badge rounded-pill bg-secondary' data-bs-toggle='tooltip' data-bs-html='true' data-bs-placement='top' title='#{sanitize(title)}'>Draft</span>"
  end

  def form_status_published_html(form)
    title = "<div class='text-left'>#{I18n.t('shared.published_at')}: #{display_date(form.published_at)}</div>"

    "<span class='badge rounded-pill bg-success' data-bs-toggle='tooltip' data-bs-html='true' data-bs-placement='top' title='#{sanitize(title)}'>Released</span>"
  end

  def chat_group_list_html(groups)
    return "" unless groups.present?
    "<div class='text-left'>" +
    "<span>#{t('form.chat_group')}</span>: " +
    "<ol>" + groups.map { |group| "<li>#{group.title}</li>" }.join("") + "</ol>" +
    "</div>"
  end

  def tag_list_html(tags)
    return "" unless tags.present?

    tags.map { |tag|
      "<small class='tag rounded me-1'>#{tag}</small>"
    }.join("")
  end
end
