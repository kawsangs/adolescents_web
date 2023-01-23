class AddNewCountToFacilityBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :facility_batches, :new_count, :integer, default: 0
  end
end
