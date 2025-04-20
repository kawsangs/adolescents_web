class RemoveTextColorFromTheme < ActiveRecord::Migration[7.0]
  def change
    remove_column :themes, :primary_text_color
    remove_column :themes, :secondary_text_color
  end
end
