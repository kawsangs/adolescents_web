class AddTaggingsCountAndDisplayOrderToTags < ActiveRecord::Migration[7.0]
  def change
    add_column :tags, :taggings_count, :integer, default: 0
    add_column :tags, :display_order, :integer, default: 0
  end
end
