class CreateThemes < ActiveRecord::Migration[7.0]
  def change
    create_table :themes, id: :uuid do |t|
      t.string :name
      t.text   :description
      t.boolean :active, default: false
      t.boolean :default, default: false
      t.string :primary_color
      t.string :secondary_color
      t.string :primary_text_color
      t.string :secondary_text_color

      t.timestamps
    end
  end
end
