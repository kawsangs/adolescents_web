class AddCommuneCodeToFacilities < ActiveRecord::Migration[7.0]
  def change
    add_column :facilities, :province_id, :string
    add_column :facilities, :district_id, :string
    add_column :facilities, :commune_id, :string
    add_column :facilities, :village_id, :string
    add_column :facilities, :street, :string
    add_column :facilities, :house_number, :string
  end
end
