class CreateOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :options, id: :uuid do |t|
      t.uuid     :question_id
      t.string   :name
      t.text     :message
      t.boolean  :move_next, default: true

      t.timestamps
    end
  end
end
