# == Schema Information
#
# Table name: videos
#
#  id                :uuid             not null, primary key
#  name              :string
#  description       :text
#  url               :string
#  display_order     :integer
#  video_category_id :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Video < ApplicationRecord
  # Association
  belongs_to :video_category, optional: true

  # Validation
  validates :name, presence: true
  validates :description, presence: true
  validates :url, presence: true, format: { with: URI.regexp(%w(http https)) }

  # Callback
  before_create :set_display_order

  # Delegation
  delegate :name, to: :video_category, prefix: true, allow_nil: true

  # Nested attribute
  def video_category_attributes=(attribute)
    self.video_category = VideoCategory.find_or_create_by(name: attribute[:name].downcase) if attribute[:name].present?
  end

  # Class methods
  def self.filter(params = {})
    scope = all
    scope = scope.where("title LIKE ?", "%#{params[:name]}%") if params[:name].present?
    scope = scope.where(category: params[:category]) if params[:category].present?
    scope
  end

  # Instant methods
  def set_display_order
    self.display_order ||= self.class.maximum(:display_order).to_i + 1
  end
end
