class RenameVisitorsToVisits < ActiveRecord::Migration[7.0]
  def self.up
    rename_table :visitors, :visits
  end

  def self.down
    rename_table :visits, :visitors
  end
end
