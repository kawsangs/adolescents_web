# == Schema Information
#
# Table name: app_user_characteristics
#
#  id                :uuid             not null, primary key
#  app_user_id       :uuid
#  characteristic_id :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class AppUserCharacteristic < ApplicationRecord
  # Association
  belongs_to :app_user
  belongs_to :characteristic

  # Nested attributes
  accepts_nested_attributes_for :characteristic, reject_if: lambda { |attributes|
    attributes["name"].blank?
  }

  def characteristic_attributes=(attribute)
    self.characteristic = Characteristic.find_by(code: attribute[:code]) if attribute[:code].present?
  end
end
