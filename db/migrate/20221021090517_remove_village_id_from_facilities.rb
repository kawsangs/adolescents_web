class RemoveVillageIdFromFacilities < ActiveRecord::Migration[7.0]
  def change
    remove_column :facilities, :village_id
  end
end
