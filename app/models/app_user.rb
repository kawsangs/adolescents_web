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
#  uuid             :string
#  deleted_at       :datetime
#
class AppUser < ApplicationRecord
  acts_as_paranoid

  GENDERS = %w(male female lgbt unknown)

  enum platform: MobileToken.platforms

  enum education_level: {
    n_a: 0,
    general_knowledge: 1,
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
  has_many :app_user_characteristics
  has_many :characteristics, through: :app_user_characteristics
  has_many :surveys
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

  def profile_html
    return "#{I18n.t('app_user.app_user')}: #{I18n.t('app_user.anonymous')}" if anonymous?

    "#{I18n.t('app_user.app_user')}: \n" +
    "#{I18n.t('app_user.gender')}: <b>" + I18n.t("app_user.#{gender}") + "</b>, " +
    "#{I18n.t('app_user.age')}: <b>#{age}</b>, " +
    "#{I18n.t('app_user.province')}: <b>#{province.name_km}</b>, " +
    "#{I18n.t('app_user.occupation')}: <b>" + I18n.t("app_user.#{occupation}") + "</b>, " +
    "#{I18n.t('app_user.education_level')}: <b>" + I18n.t("app_user.#{education_level}") + "</b>, " +
    "#{I18n.t('app_user.characteristic')}: <b>#{characteristics.map(&:name_en).join(', ') || '_'}</b>"
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

  def self.find_for_archive(params = {})
    user = find_or_initialize_by(params.slice(:uuid))
    user.errors.add(:uuid, I18n.t("app_user.cannot_be_blank")) if params[:uuid].blank?
    user
  end

  private
    def set_province_id
      self.province_id ||= Location::UNKNOWN_PROVINCE_ID
    end

    def set_last_accessed_at
      self.last_accessed_at = registered_at
    end
end
