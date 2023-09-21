class RenameTableQuizzesToSurveys < ActiveRecord::Migration[7.0]
  def change
    rename_table :quizzes, :surveys
  end
end
