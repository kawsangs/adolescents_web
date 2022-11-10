class CreateVideoBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :video_batches, id: :uuid do |t|
      t.string  :code
      t.integer :total_count, default: 0
      t.integer :valid_count, default: 0
      t.string  :filename
      t.integer :user_id

      t.timestamps
    end
  end
end
