# == Schema Information
#
# Table name: batches
#
#  id             :uuid             not null, primary key
#  code           :string
#  total_count    :integer          default(0)
#  valid_count    :integer          default(0)
#  new_count      :integer          default(0)
#  province_count :integer          default(0)
#  reference      :string
#  creator_id     :integer
#  type           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Batch < ApplicationRecord
  # Association
  belongs_to :creator, class_name: "User"
  has_many :importing_items, dependent: :destroy
  has_many :categories, through: :importing_items, source: :itemable, source_type: "Category"

  # Uploader
  mount_uploader :reference, AttachmentUploader

  # Nested attributes
  accepts_nested_attributes_for :importing_items

  # Callback
  before_create :secure_code

  # Delegation
  delegate :email, to: :creator, prefix: :creator, allow_nil: true

  # Instant method
  def edit_count
    total_count - new_count
  end

  def invalid_count
    total_count - valid_count
  end

  # Class method
  def self.filter(params)
    keyword = params[:keyword].to_s.strip
    scope = all
    scope = scope.where("code LIKE ? OR filename LIKE ?", "%#{keyword}%", "%#{keyword}%") if keyword.present?
    scope
  end
end
