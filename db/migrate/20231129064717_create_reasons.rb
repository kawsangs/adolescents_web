class CreateReasons < ActiveRecord::Migration[7.0]
  def change
    create_table :reasons, id: :uuid do |t|
      t.string :code
      t.string :name_km
      t.string :name_en
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
