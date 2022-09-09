class AddSignInTypeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :sign_in_type, :integer, default: 1
  end
end
