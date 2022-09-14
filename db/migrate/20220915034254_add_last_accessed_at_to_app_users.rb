class AddLastAccessedAtToAppUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :app_users, :last_accessed_at, :datetime
  end
end
