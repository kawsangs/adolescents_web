module ApplicationHelper
  include Pagy::Frontend

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

  def system_locales
    [
      { code: "km", label: I18n.t("user.locale_km"), image: "khmer.png" },
      { code: "en", label: I18n.t("user.locale_en"), image: "english.png" }
    ]
  end

  def link_to_add_fields(name, f, association, option = {})
    new_object = f.object.send(association).klass.new
    id = new_object.object_id

    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder, option: option)
    end

    link_to(name, "#", class: "add_#{association} btn", data: { id: id, fields: fields.gsub("\n", "") }.merge(option) )
  end
end
