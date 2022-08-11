class CreateVisitors < ActiveRecord::Migration[7.0]
  def change
    create_table :visitors, id: :uuid do |t|
      t.string :device_id
      t.uuid   :page_id
      t.uuid   :platform_id
      t.datetime :visit_date

      t.timestamps
    end
  end
end
