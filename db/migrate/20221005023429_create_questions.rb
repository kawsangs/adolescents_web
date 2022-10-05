class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions, id: :uuid do |t|
      t.string  :code
      t.text    :name
      t.string  :type
      t.string  :hint
      t.integer :display_order
      t.string  :audio
      t.uuid    :topic_id

      t.timestamps
    end
  end
end
