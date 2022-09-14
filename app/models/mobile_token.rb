# == Schema Information
#
# Table name: mobile_tokens
#
#  id          :uuid             not null, primary key
#  device_id   :string
#  device_type :integer
#  token       :string
#  app_version :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class MobileToken < ApplicationRecord
  validates :token, presence: true
  validates :device_id, presence: true
  validates :device_type, presence: true
  validates :app_version, presence: true

  enum device_type: {
    mobile: 1,
    tablet: 2,
    unknown: 3
  }

  def self.filter(params = {})
    scope = all
    scope = scope.where(app_version: params[:app_versions]) if params[:app_versions].present?
    scope
  end
end
