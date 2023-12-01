# == Schema Information
#
# Table name: reasons
#
#  id         :uuid             not null, primary key
#  code       :string
#  name_km    :string
#  name_en    :string
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Reason < ApplicationRecord
  # Soft delete
  acts_as_paranoid

  # Validation
  validates :name_km, presence: true
  validates :name_en, presence: true

  # Association
  has_many :app_user_reasons, primary_key: :code, foreign_key: :reason_code
  has_many :app_users, through: :app_user_reasons

  # Callback
  before_create :secure_code

  # Instant methods
  def name
    self["name_#{I18n.locale}"]
  end

  # Class methods
  def self.filter(params = {})
    param_name = params[:name].to_s.strip
    scope = all
    scope = scope.where("code LIKE ? OR name_km LIKE ? OR name_en LIKE ?", "%#{param_name}%", "%#{param_name}%", "%#{param_name}%") if param_name.present?
    scope
  end
end
