class AddTaggableIdAndTaggableTypeToTaggings < ActiveRecord::Migration[7.0]
  def change
    add_column :taggings, :taggable_id, :uuid
    add_column :taggings, :taggable_type, :string
  end
end
