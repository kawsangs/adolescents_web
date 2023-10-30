# frozen_string_literal: true

module QuestionsHelper
  def option_list_item(question_type, option)
    render partial: "shared/options/#{partial_name(question_type)}", locals: { option: }
  rescue
    "<li>#{option.name} (#{option.value})</li>".html_safe
  end

  # Example: select_one
  def partial_name(question_type)
    type = question_type.split("::").last
    type.split(/(?=[A-Z])/).map(&:downcase).join("_")
  end
end
