class AddVisitsCountToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :visits_count, :integer, default: 0
  end
end
