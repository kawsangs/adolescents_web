# == Schema Information
#
# Table name: topics
#
#  id           :uuid             not null, primary key
#  name_km      :string
#  version      :integer          default(0)
#  published_at :datetime
#  audio        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  code         :string
#  name_en      :string
#
class Topic < ApplicationRecord
  include Taggable

  # Association
  has_many :questions, dependent: :destroy
  has_many :topic_services, dependent: :destroy
  has_many :services, through: :topic_services

  # Validation
  validates :name_km, presence: true
  validates :name_en, presence: true

  # Mount audio
  mount_uploader :audio, AudioUploader

  # Scope
  default_scope { order("created_at") }
  scope :published, -> { where.not(published_at: nil) }

  # Nested attribute
  accepts_nested_attributes_for :questions, allow_destroy: true

  # Callback
  before_update :upgrade_version, if: :published_at_changed?

  def self.filter(params = {})
    scope = all
    scope = scope.where("name LIKE ?", "%#{params[:name]}%") if params[:name].present?
    scope
  end

  def name
    self["name_#{I18n.locale}"]
  end

  def published?
    published_at.present?
  end

  private
    def upgrade_version
      self.version += 1
    end
end
