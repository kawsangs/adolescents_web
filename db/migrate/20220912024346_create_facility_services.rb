class CreateFacilityServices < ActiveRecord::Migration[7.0]
  def change
    create_table :facility_services, id: :uuid do |t|
      t.uuid :facility_id
      t.uuid :service_id

      t.timestamps
    end
  end
end
