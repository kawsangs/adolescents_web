class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers, id: :uuid do |t|
      t.uuid   :quiz_id
      t.uuid   :question_id
      t.uuid   :option_id
      t.string :value

      t.timestamps
    end
  end
end
