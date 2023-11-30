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
  # Soft delete
  acts_as_paranoid

  include AppUsers::FilterConcern
  include AppUsers::NotifiableMessageConcern
  include AppUsers::ScheduleDeletionConcern

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

  has_many :app_user_reasons
  has_many :reasons, through: :app_user_reasons

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

  private
    def set_province_id
      self.province_id ||= Location::UNKNOWN_PROVINCE_ID
    end

    def set_last_accessed_at
      self.last_accessed_at = registered_at
    end
end
