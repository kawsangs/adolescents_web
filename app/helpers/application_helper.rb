module ApplicationHelper
  def css_class_name
    "#{controller_path.parameterize}-#{action_name}"
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : "sortable"
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, { sort: column, direction: }, { class: css_class }
  end

  def timeago(date)
    return "" unless date.present?

    str = "<span class='timeago' data-date='#{I18n.l(date, format: "%Y-%m-%d")}'>"
    str += time_ago_in_words(date)
    str += "</span>"
    str
  end

  def css_active_class(controller_name)
    return "active" if request.path.split("/")[1] == controller_name
  end
end
