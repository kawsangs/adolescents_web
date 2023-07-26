class RemoveVideoCategoryIdFromVideos < ActiveRecord::Migration[7.0]
  def change
    remove_column :videos, :video_category_id
    remove_column :videos, :author

    drop_table :video_categories
  end
end
