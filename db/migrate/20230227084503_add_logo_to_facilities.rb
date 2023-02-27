class AddLogoToFacilities < ActiveRecord::Migration[7.0]
  def change
    add_column :facilities, :logo, :string
  end
end
