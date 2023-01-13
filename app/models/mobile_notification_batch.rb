# == Schema Information
#
# Table name: mobile_notification_batches
#
#  id          :bigint           not null, primary key
#  code        :string
#  total_count :integer          default(0)
#  valid_count :integer          default(0)
#  filename    :string
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class MobileNotificationBatch < ApplicationRecord
  belongs_to :user
  has_many :mobile_notifications

  # Callback
  before_create :secure_code
  validate :validate_notifications

  # Delegation
  delegate :email, to: :user, prefix: :user

  # Nested attribute
  accepts_nested_attributes_for :mobile_notifications

  def self.filter(params)
    keyword = params[:keyword].to_s.strip
    scope = all
    scope = scope.where("code LIKE ? OR filename LIKE ?", "%#{keyword}%", "%#{keyword}%") if keyword.present?
    scope
  end

  private
    def validate_notifications
      return if mobile_notifications.map { |a| a.valid? }.all?

      errors.add(:mobile_notifications, "There are some invalid records")
      throw(:abort)
    end
end
