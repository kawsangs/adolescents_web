class AddImageToOptions < ActiveRecord::Migration[7.0]
  def change
    add_column :options, :image, :string
  end
end
