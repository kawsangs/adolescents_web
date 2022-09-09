class CreateCharacteristics < ActiveRecord::Migration[7.0]
  def change
    create_table :characteristics, id: :uuid do |t|
      t.string :code
      t.string :name_en
      t.string :name_km

      t.timestamps
    end
  end
end
