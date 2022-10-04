# == Schema Information
#
# Table name: app_users
#
#  id               :uuid             not null, primary key
#  gender           :string
#  age              :integer
#  province_id      :string
#  registered_at    :datetime
#  device_id        :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  last_accessed_at :datetime
#
class AppUser < ApplicationRecord
  GENDERS = %w(male female lgbt unknown)

  # Validation
  validates :gender, presence: true, unless: :anonymous?
  validates :gender, inclusion: { in: GENDERS, allow_nil: true }

  validates :age, presence: true
  validates :province_id, presence: true, unless: :anonymous?
  validates :device_id, presence: true
  validates :registered_at, presence: true

  # Association
  has_many :app_user_characteristics, dependent: :destroy
  has_many :characteristics, through: :app_user_characteristics
  belongs_to :location, foreign_key: :province_id, optional: true

  # Callback
  before_create :set_last_accessed_at

  # Nested attributes
  accepts_nested_attributes_for :app_user_characteristics

  def anonymous?
    age == -1
  end

  def province
    @province ||= Pumi::Province.find_by_id province_id
  end

  def set_last_accessed_at
    self.last_accessed_at = registered_at
  end

  # Class method
  def self.filter(params = {})
    scope = all
    scope = scope.where("registered_at BETWEEN ? AND ?", DateTime.parse(params[:start_date]).beginning_of_day, DateTime.parse(params[:end_date]).end_of_day) if params[:start_date].present? && params[:end_date].present?
    scope = scope.where(province_id: params[:province_ids]) if params[:province_ids].present?
    scope = scope.where(gender: params[:genders]) if params[:genders].present?
    scope = scope.where("age BETWEEN ? AND ?", params[:start_age], params[:end_age]) if params[:start_age].present? && params[:end_age].present?
    scope = scope.joins(:app_user_characteristics).where("app_user_characteristics.characteristic_id": params[:characteristic_ids]) if params[:characteristic_ids].present?
    scope
  end
end
