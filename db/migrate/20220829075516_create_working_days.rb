class CreateWorkingDays < ActiveRecord::Migration[7.0]
  def change
    create_table :working_days, id: :uuid do |t|
      t.uuid :facility_id
      t.integer :day, default: 0
      t.boolean :open, default: false

      t.timestamps
    end
  end
end
