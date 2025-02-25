class CreateThemes < ActiveRecord::Migration[7.0]
  def change
    create_table :themes, id: :uuid do |t|
      t.string :name
      t.text   :description
      t.boolean :active, default: false
      t.boolean :default, default: false
      t.timestamps
    end
  end
end
