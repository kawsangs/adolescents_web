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
#  platform         :integer          default("android")
#  occupation       :integer          default("n_a")
#  education_level  :integer          default("n_a")
#
class AppUser < ApplicationRecord
  GENDERS = %w(male female lgbt unknown)

  enum platform: MobileToken.platforms

  enum education_level: {
    n_a: 0,
    under_grade_twelve: 1,
    university: 2,
    tvet: 3,
    dropout_student: 4
  }, _prefix: :education

  enum occupation: {
    n_a: 0,
    student: 1,
    entertainment_worker: 2,
    factory_worker: 3,
    local_migrant_worker: 4,
    oversea_migrant_worker: 5,
    other: 6
  }

  # Validation
  validates :gender, presence: true, unless: :anonymous?
  validates :gender, inclusion: { in: GENDERS, allow_nil: true }

  validates :occupation, presence: true, unless: :anonymous?
  validates :occupation, inclusion: { in: occupations.keys, allow_nil: true }

  validates :education_level, presence: true, unless: :anonymous?
  validates :education_level, inclusion: { in: education_levels.keys, allow_nil: true }

  validates :age, presence: true
  validates :province_id, presence: true
  validates :device_id, presence: true
  validates :registered_at, presence: true

  # Association
  belongs_to :location, foreign_key: :province_id, optional: true
  has_many :app_user_characteristics, dependent: :destroy
  has_many :characteristics, through: :app_user_characteristics
  has_many :quizzes
  has_many :visits

  # Callback
  before_create :set_last_accessed_at
  before_validation :set_province_id

  # Nested attributes
  accepts_nested_attributes_for :app_user_characteristics

  # Instant methods
  def anonymous?
    age == -1
  end

  def province
    @province ||= Pumi::Province.find_by_id province_id
  end

  def display_device_id
    return device_id if device_id.length <= 6

    device_id.first(3) + "..." + device_id.last(3)
  end

  # Class method
  def self.filter(params = {})
    scope = all
    scope = scope.where("registered_at BETWEEN ? AND ?", DateTime.parse(params[:start_date]).beginning_of_day, DateTime.parse(params[:end_date]).end_of_day) if params[:start_date].present? && params[:end_date].present?
    scope = scope.where(province_id: params[:province_ids]) if params[:province_ids].present?
    scope = scope.where(gender: params[:genders]) if params[:genders].present?
    scope = scope.where("age BETWEEN ? AND ?", params[:start_age], params[:end_age]) if params[:start_age].present? && params[:end_age].present?
    scope = scope.joins(:app_user_characteristics).where("app_user_characteristics.characteristic_id": params[:characteristic_ids]) if params[:characteristic_ids].present?
    scope = scope.where(platform: params[:platform]) if params[:platform].present?
    scope
  end

  private
    def set_province_id
      self.province_id ||= Location::UNKNOWN_PROVINCE_ID
    end

    def set_last_accessed_at
      self.last_accessed_at = registered_at
    end
end
