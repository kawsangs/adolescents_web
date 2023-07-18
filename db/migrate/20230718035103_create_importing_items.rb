class CreateImportingItems < ActiveRecord::Migration[7.0]
  def change
    create_table :importing_items, id: :uuid do |t|
      t.uuid   :itemable_id
      t.string :itemable_type
      t.uuid   :batch_id

      t.timestamps
    end
  end
end
