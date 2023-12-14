class AddVizCodeToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :viz_code, :string
  end
end
