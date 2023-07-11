class AddOccupationToAppUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :app_users, :occupation, :integer, default: 0
    add_column :app_users, :education_level, :integer, default: 0
  end
end
