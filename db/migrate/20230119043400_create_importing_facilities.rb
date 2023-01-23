class CreateImportingFacilities < ActiveRecord::Migration[7.0]
  def change
    create_table :importing_facilities do |t|
      t.uuid :facility_id
      t.uuid :facility_batch_id

      t.timestamps
    end
  end
end
