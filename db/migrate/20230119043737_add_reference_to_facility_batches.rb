class AddReferenceToFacilityBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :facility_batches, :reference, :string
  end
end
