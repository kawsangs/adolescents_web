class AddActiveToMobileTokens < ActiveRecord::Migration[7.0]
  def change
    add_column :mobile_tokens, :active, :boolean, default: true
  end
end
