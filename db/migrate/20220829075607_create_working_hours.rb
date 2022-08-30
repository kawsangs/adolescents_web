class CreateWorkingHours < ActiveRecord::Migration[7.0]
  def change
    create_table :working_hours, id: :uuid do |t|
      t.uuid :working_day_id
      t.integer :open_at
      t.integer :close_at

      t.timestamps
    end
  end
end
