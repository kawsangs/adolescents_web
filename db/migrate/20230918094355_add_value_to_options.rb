class AddValueToOptions < ActiveRecord::Migration[7.0]
  def change
    add_column :options, :value, :string
  end
end
