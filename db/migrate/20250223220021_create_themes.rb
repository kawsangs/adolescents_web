class CreateThemes < ActiveRecord::Migration[7.0]
  def change
    create_table :themes, id: :uuid do |t|
      t.string :name
      t.text   :description
      t.boolean :active, default: false
      t.boolean :default, default: false
      t.string :bg_color
      t.string :text_color
      t.string :button_color
      t.string :nav_bar_color
      t.timestamps
    end
  end
end
