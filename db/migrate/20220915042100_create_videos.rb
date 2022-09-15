class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos, id: :uuid do |t|
      t.string :name
      t.text   :description
      t.string :url
      t.integer :display_order
      t.uuid :video_category_id

      t.timestamps
    end
  end
end
