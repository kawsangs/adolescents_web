class CreateAssets < ActiveRecord::Migration[7.0]
  def change
    create_table :assets, id: :uuid do |t|
      t.string :name
      t.integer :platform
      t.string :resolution  # e.g., "1x", "2x", "3x", "mdpi", "hdpi", etc.
      t.uuid   :theme_id
      t.string :image
      
      t.timestamps
    end
  end
end
