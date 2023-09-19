class CreateSections < ActiveRecord::Migration[7.0]
  def change
    create_table :sections, id: :uuid do |t|
      t.string  :name
      t.uuid    :topic_id
      t.integer :display_order

      t.timestamps
    end
  end
end
