class CreateQuizzes < ActiveRecord::Migration[7.0]
  def change
    create_table :quizzes, id: :uuid do |t|
      t.uuid     :app_user_id
      t.uuid     :topic_id
      t.datetime :quizzed_at

      t.timestamps
    end
  end
end
