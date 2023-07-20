# == Schema Information
#
# Table name: categories
#
#  id             :uuid             not null, primary key
#  code           :string
#  name           :string
#  image          :string
#  audio          :string
#  description    :text
#  parent_id      :uuid
#  lft            :integer          not null
#  rgt            :integer          not null
#  depth          :integer          default(0), not null
#  children_count :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Category < ApplicationRecord
  include Taggable

  # Uploader
  mount_uploader :image, ImageUploader
  mount_uploader :audio, AudioUploader

  # Association
  has_many :content_sources

  # Validation
  validates :name, presence: true

  # Nested level
  acts_as_nested_set counter_cache: :children_count, touch: true

  # Nested attribute
  accepts_nested_attributes_for :content_sources, allow_destroy: true

  # Callback
  before_create :secure_code

  # Delegation
  delegate :name, :code, to: :parent, prefix: :parent, allow_nil: true

  # Class method
  def self.filter(params = {})
    scope = all
    scope = scope.where("name LIKE ?", "%#{params[:name]}%") if params[:name].present?
    scope
  end
end
