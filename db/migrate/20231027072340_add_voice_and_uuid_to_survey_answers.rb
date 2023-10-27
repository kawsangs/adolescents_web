class AddVoiceAndUuidToSurveyAnswers < ActiveRecord::Migration[7.0]
  def change
    add_column :survey_answers, :uuid, :string
    add_column :survey_answers, :voice, :string
  end
end
