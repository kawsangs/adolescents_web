class RemoveDisplayNameFromPages < ActiveRecord::Migration[7.0]
  def change
    remove_column :pages, :display_name
  end
end
