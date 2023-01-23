# == Schema Information
#
# Table name: facility_batches
#
#  id             :uuid             not null, primary key
#  code           :string
#  total_count    :integer          default(0)
#  valid_count    :integer          default(0)
#  province_count :integer          default(0)
#  filename       :string
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  reference      :string
#  new_count      :integer          default(0)
#
class FacilityBatch < ApplicationRecord
  attr_accessor :importing_clinics

  # Uploader
  mount_uploader :reference, AttachmentUploader

  # Association
  belongs_to :user
  has_many :importing_facilities
  has_many :facilities, through: :importing_facilities

  # Callback
  before_create :secure_code

  # Delegation
  delegate :email, to: :user, prefix: :user

  # Nested attributes
  accepts_nested_attributes_for :importing_facilities

  # Instant method
  def edit_count
    valid_count - new_count
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
