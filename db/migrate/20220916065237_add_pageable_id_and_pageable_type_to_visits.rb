class AddPageableIdAndPageableTypeToVisits < ActiveRecord::Migration[7.0]
  def change
    add_column :visits, :pageable_id, :uuid
    add_column :visits, :pageable_type, :integer
  end
end
