# == Schema Information
#
# Table name: mobile_tokens
#
#  id          :uuid             not null, primary key
#  device_id   :string
#  device_type :string
#  token       :string
#  app_version :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  platform    :integer          default("android")
#
class MobileToken < ApplicationRecord
  validates :token, presence: true
  validates :device_id, presence: true
  validates :device_type, presence: true
  validates :app_version, presence: true

  enum platform: {
    android: 1,
    ios: 2
  }

  PLATFORMS = [["Android", "android"], ["iOs", "ios"]]

  def self.filter(params = {})
    scope = all
    scope = scope.where(app_version: params[:app_versions]) if params[:app_versions].present?
    scope = scope.where(platform: params[:platform]) if params[:platform].present?
    scope
  end
end
