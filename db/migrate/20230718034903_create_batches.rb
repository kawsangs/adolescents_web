class CreateBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :batches, id: :uuid do |t|
      t.string  :code
      t.integer :total_count, default: 0
      t.integer :valid_count, default: 0
      t.integer :new_count, default: 0
      t.integer :province_count, default: 0
      t.string  :reference
      t.integer :creator_id
      t.string  :type

      t.timestamps
    end
  end
end
