# == Schema Information
#
# Table name: videos
#
#  id              :uuid             not null, primary key
#  name            :string
#  description     :text
#  url             :string
#  display_order   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  video_batch_id  :uuid
#  video_author_id :uuid
#
class Video < ApplicationRecord
  include Taggable
  include ItemableConcern

  # Association
  belongs_to :video_author, optional: true, counter_cache: true

  # Validation
  validates :name, presence: true
  validates :url, presence: true, format: { with: URI.regexp(%w(http https)) }

  # Callback
  before_create :set_display_order

  # Scope
  default_scope { order(display_order: :asc) }

  # Delegation
  delegate :name, to: :video_author, prefix: true, allow_nil: true

  # Nested attribute
  def video_author_attributes=(attribute)
    self.video_author = VideoAuthor.find_or_create_by(name: attribute[:name]) if attribute[:name].present?
  end

  # Class methods
  def self.filter(params = {})
    scope = all
    scope = scope.where("name LIKE ?", "%#{params[:name]}%") if params[:name].present?
    scope = scope.joins(:importing_items).joins(:batches).where("batches.code = ?", params[:batch_code]) if params[:batch_code].present?
    scope = scope.joins(:video_author).where("video_authors.name IN (?)", params[:video_author]) if params[:video_author].present?
    scope = scope.joins(taggings: :tag).where("tags.name IN (?)", params[:tag]) if params[:tag].present?
    scope
  end

  def youtube_id
    regex = /(?:youtube(?:-nocookie)?\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/
    match = regex.match(url)
    if match && !match[1].blank?
      match[1]
    else
      nil
    end
  end

  def thumbnail
    "http://img.youtube.com/vi/#{youtube_id}/default.jpg"
  end
end
