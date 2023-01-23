module FacilitiesHelper
  def hour_list
    [[], ["24h", 24]] +
    (0..11).map { |i| [ "#{i}:00 AM", i] } +
    [["12:00 PM", 12]] +
    (1..11).map { |i| [ "#{i}:00 PM", i + 12] }
  end

  def status_class(facility)
    return "invalid" unless facility.valid?

    facility.new_record? ? "new" : "edit"
  end

  def status_message(facility)
    return facility.errors.full_messages.join(", ") unless facility.valid?

    facility.new_record? ? I18n.t("shared.new") : I18n.t("shared.edit")
  end
end
