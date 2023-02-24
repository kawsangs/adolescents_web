class AddNameEnToTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :name_en, :string
    rename_column :topics, :name, :name_km
  end
end
