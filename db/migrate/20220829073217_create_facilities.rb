class CreateFacilities < ActiveRecord::Migration[7.0]
  def change
    create_table :facilities, id: :uuid do |t|
      t.string :name
      t.string :address
      t.string :tels, array: true, default: []
      t.string :emails, array: true, default: []
      t.string :websites, array: true, default: []
      t.string :facebook_pages, array: true, default: []
      t.string :telegram_username
      t.text   :description
      t.float  :latitude
      t.float  :longitude
      t.uuid   :facility_batch_id

      t.timestamps
    end
  end
end
