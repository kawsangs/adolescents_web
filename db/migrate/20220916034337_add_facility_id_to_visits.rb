class AddFacilityIdToVisits < ActiveRecord::Migration[7.0]
  def change
    add_column :visits, :facility_id, :uuid
  end
end
