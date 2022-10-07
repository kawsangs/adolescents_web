class ChangeEncryptedPasswordInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :encrypted_password, :string, null: true
  end
end
