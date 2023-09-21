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
#  type         :string
#  description  :text
#
class Topic < ApplicationRecord
  include Taggable

  # Association
  has_many :questions
  has_many :sections, dependent: :destroy, inverse_of: :topic

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
  accepts_nested_attributes_for :sections, allow_destroy: true

  # Callback
  before_update :upgrade_version, if: :published_at_changed?

  def self.filter(params = {})
    param_name = params[:name].to_s.strip
    scope = all
    scope = scope.where("name_km LIKE ? OR name_en LIKE ?", "%#{param_name}%", "%#{param_name}%") if param_name.present?
    scope
  end

  def name
    self["name_#{I18n.locale}"]
  end

  def published?
    published_at.present?
  end

  def publish
    update(published_at: Time.now)
  end

  def status
    published? ? "published" : "draft"
  end

  private
    def upgrade_version
      self.version += 1
    end
end
