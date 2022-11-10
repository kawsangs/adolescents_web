class ChangeColumnDeviceTypeInMobileTokens < ActiveRecord::Migration[7.0]
  def change
    change_column :mobile_tokens, :device_type, :string
  end
end
