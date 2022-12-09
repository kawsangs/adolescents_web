class AddPlatformToMobileTokens < ActiveRecord::Migration[7.0]
  def change
    add_column :mobile_tokens, :platform, :integer, default: 1
  end
end
