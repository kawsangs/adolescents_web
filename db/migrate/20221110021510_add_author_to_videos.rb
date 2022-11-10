class AddAuthorToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :author, :string
    add_column :videos, :video_batch_id, :uuid
  end
end
