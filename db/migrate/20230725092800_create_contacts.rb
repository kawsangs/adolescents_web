class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts, id: :uuid do |t|
      t.string :name
      t.string :value
      t.string :type
      t.uuid   :contact_directory_id
      t.integer :display_order

      t.timestamps
    end
  end
end
