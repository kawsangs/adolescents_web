class AddDeviceOsToMobileTokens < ActiveRecord::Migration[7.0]
  def change
    add_column :mobile_tokens, :device_os, :string
  end
end
