class AddVideoAuthorIdToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :video_author_id, :uuid
  end
end
