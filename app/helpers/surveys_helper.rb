module SurveysHelper
  def build_csv_data(survey_form, surveys)
    CSV.generate(headers: true) do |csv|
      csv << build_survey_header(survey_form)

      surveys.each do |survey|
        csv << build_survey_row(survey, survey_form)
      end
    end
  end

  def build_survey_header(survey_form)
    user_headers = %w[id gender age province occupation educationlevel characteristic]
    question_headers = survey_form.questions.map(&:name)
    time_headers = %w[submission_time quizzed_time]
    user_headers + question_headers + time_headers
  end

  def build_survey_row(survey, survey_form)
    user = survey.app_user
    row = [
      user.id[0..7],
      user.gender || "annonymous",
      (user.age unless user.anonymous?),
      (user.province["name_#{I18n.locale}"] unless user.anonymous?),
      t("app_user.#{user.occupation}"),
      t("app_user.#{user.education_level}"),
      user.characteristics.map(&:"name_#{I18n.locale}").join(", ")
    ]
    row.concat survey_form.questions.map { |question| survey.survey_answers_for(question.id).option_name }
    row.concat [survey.created_at, survey.quizzed_at]
    row
  end
end
