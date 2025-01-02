class AddIndexToVisitDateInVisits < ActiveRecord::Migration[7.0]
  def change
    add_index :visits, :visit_date, if_not_exists: true
  end
end
