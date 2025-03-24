# == Schema Information
#
# Table name: themes
#
#  id                   :uuid             not null, primary key
#  name                 :string
#  status               :integer          default("draft")
#  default              :boolean          default(FALSE)
#  primary_color        :string
#  secondary_color      :string
#  primary_text_color   :string
#  secondary_text_color :string
#  published_at         :datetime
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Theme < ApplicationRecord
  # Enum
  enum status: {
    draft: 0,
    published: 1
  }

  # Soft delete
  acts_as_paranoid

  # Association
  has_many :assets, dependent: :destroy

  # Validation
  validates :name, presence: true, uniqueness: true, length: { maximum: 15 }
  validates :primary_color, presence: true
  validates :secondary_color, presence: true
  validates :primary_text_color, presence: true
  validates :secondary_text_color, presence: true

  # Scope
  scope :published, -> { where(status: :published) }
  scope :defaults, -> { where(default: true) } # for built-in theme
  scope :by_name, ->(name) { where("name ILIKE ?", "%#{name.strip}%") if name.present? }
  scope :from_date, ->(timestamp) do
    where("updated_at > ?", Time.zone.at(timestamp.to_i)).order(updated_at: :asc) if timestamp.to_i.positive?
  end

  # Nested attribute
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: ->(attributes) { attributes["image"].blank? }

  # Instant method
  def publish
    update(published_at: Time.now, status: "published")
  end
end
