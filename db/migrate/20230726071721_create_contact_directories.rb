class CreateContactDirectories < ActiveRecord::Migration[7.0]
  def change
    create_table :contact_directories, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
  end
end
