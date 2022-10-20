class AddDisplayNameToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :display_name, :string
  end
end
