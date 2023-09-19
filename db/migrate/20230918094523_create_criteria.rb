class CreateCriteria < ActiveRecord::Migration[7.0]
  def change
    create_table :criteria, id: :uuid do |t|
      t.uuid    :question_id
      t.string  :question_code
      t.string  :operator
      t.string  :response_value

      t.timestamps
    end
  end
end
