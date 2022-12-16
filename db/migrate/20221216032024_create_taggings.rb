class CreateTaggings < ActiveRecord::Migration[7.0]
  def change
    create_table :taggings do |t|
      t.uuid :tag_id
      t.uuid :facility_id

      t.timestamps
    end
  end
end
