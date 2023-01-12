# == Schema Information
#
# Table name: mobile_notifications
#
#  id                           :bigint           not null, primary key
#  title                        :string
#  body                         :text
#  success_count                :integer
#  failure_count                :integer
#  creator_id                   :integer
#  app_versions                 :string           default([]), is an Array
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  platform                     :integer
#  schedule_date                :datetime
#  mobile_notification_batch_id :integer
#  job_id                       :string
#
class MobileNotification < ApplicationRecord
  include MobileNotifications::Callback

  # Association
  belongs_to :creator, foreign_key: :creator_id, class_name: "User"
  belongs_to :mobile_notification_batch, optional: true

  # Valiation
  validates :title, presence: true, length: { maximum: 64 }
  validates :body, presence: true, length: { maximum: 255 }

  # Callback
  before_destroy :check_schedule_date

  # Enum
  enum platform: MobileToken.platforms

  # Instant method
  def build_content
    { notification: { title:, body: }, apns: { payload: { aps: { "content-available": 1 } } }, android: { "priority": "high" } }
  end

  def description
    return nil if success_count.nil?

    I18n.t("mobile_notification.description",
      success_count:,
      failure_count:
    )
  end

  def status_html
    return "<span class='badge bg-success'>Delivered</span>" if success_count.present?

    "<span class='badge bg-warning text-dark'>Pending</span>"
  end

  def removeable?
    schedule_date.present? && schedule_date > Time.zone.now
  end

  # Class method
  def self.filter(params = {})
    scope = all
    scope = scope.where("title LIKE ?", "%#{params[:title]}%") if params[:title].present?
    scope
  end

  private
    def check_schedule_date
      return true if removeable?

      errors.add :base, "Cannot delete past schedule date notification!"

      throw(:abort)
    end
end
