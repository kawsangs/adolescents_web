class CreateVideoAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :video_authors, id: :uuid do |t|
      t.string :name
      t.integer :videos_count, default: 0
      t.integer :display_order, default: 0

      t.timestamps
    end
  end
end
