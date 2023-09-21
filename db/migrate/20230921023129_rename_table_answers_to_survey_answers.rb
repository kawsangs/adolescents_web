class RenameTableAnswersToSurveyAnswers < ActiveRecord::Migration[7.0]
  def change
    rename_table :answers, :survey_answers
    rename_column :survey_answers, :quiz_id, :survey_id
  end
end
