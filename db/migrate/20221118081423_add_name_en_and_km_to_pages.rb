class AddNameEnAndKmToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :name_en, :string
    add_column :pages, :name_km, :string
  end
end
