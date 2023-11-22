class AddUuidAndDeletedAtToAppUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :app_users, :uuid, :string
    add_column :app_users, :deleted_at, :datetime
  end
end
