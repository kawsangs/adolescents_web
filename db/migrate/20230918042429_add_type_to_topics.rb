class AddTypeToTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :type, :string
    add_column :topics, :description, :text
  end
end
