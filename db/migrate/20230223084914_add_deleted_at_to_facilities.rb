class AddDeletedAtToFacilities < ActiveRecord::Migration[7.0]
  def change
    add_column :facilities, :deleted_at, :datetime
    add_index :facilities, :deleted_at
  end
end
