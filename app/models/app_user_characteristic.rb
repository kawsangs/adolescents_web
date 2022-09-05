class AppUserCharacteristic < ApplicationRecord
  # Association
  belongs_to :app_user
  belongs_to :characteristic

  # Nested attributes
  accepts_nested_attributes_for :characteristic, reject_if: lambda { |attributes|
    attributes["name"].blank?
  }

  def characteristic_attributes=(attribute)
    self.characteristic = Characteristic.find_or_create_by(name: attribute[:name].downcase) if attribute[:name].present?
  end
end
