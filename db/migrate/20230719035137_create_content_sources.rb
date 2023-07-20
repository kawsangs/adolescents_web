class CreateContentSources < ActiveRecord::Migration[7.0]
  def change
    create_table :content_sources, id: :uuid do |t|
      t.string :name
      t.string :url
      t.uuid   :category_id

      t.timestamps
    end
  end
end
