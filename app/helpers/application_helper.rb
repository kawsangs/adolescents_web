module ApplicationHelper
  include Pagy::Frontend

  def css_class_name
    "#{controller_path.parameterize}-#{action_name}"
  end

  def css_active_class(controller_name, *other)
    return "active" if params[:controller] == controller_name || other.include?(params[:controller])
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : "sortable"
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, { sort: column, direction: }, { class: css_class }
  end

  def timeago(date, type = "date")
    return "" unless date.present?

    dis_date = type == "date" ? display_date(date) : display_datetime(date)
    str = "<span class='timeago' data-date='#{dis_date}'>"
    str += time_ago_in_words(date)
    str += "</span>"
    str
  end

  def display_date(date)
    return "" unless date.present?

    I18n.l(date, format: :yyyy_mm_dd)
  end

  def display_datetime(date)
    return "" unless date.present?

    I18n.l(date, format: :yyyy_mm_dd_time)
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
      render(association.to_s.singularize + "_fields", f: builder, option:)
    end

    link_to(name, "#", class: "add_#{association} btn add_association", data: { id:, fields: fields.gsub("\n", "") }.merge(option))
  end

  def form_check_toggle(option = {})
    disabled = option[:disabled].present? ? "disabled" : ""
    checked = option[:checked].present? ? "checked" : ""

    str = "<div class='form-check'>"
    str += "<label class='form-check-label form-check-toggle'>"
    str += "<input type='hidden' name='#{option[:name]}' value='0'/>"
    str += "<input type='checkbox' id='#{option[:id]}' name='#{option[:name]}' #{checked} #{disabled}/>"
    str += "<span>#{option[:label]}</span>"
    str += "</label>"
    str + "</div>"
  end
end
