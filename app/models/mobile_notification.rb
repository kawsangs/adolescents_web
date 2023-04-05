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
#  status                       :integer          default("pending")
#  detail                       :json
#
class MobileNotification < ApplicationRecord
  include MobileNotifications::Callback

  # to support excel import
  attr_accessor :schedule_at

  # Association
  belongs_to :creator, foreign_key: :creator_id, class_name: "User"
  belongs_to :mobile_notification_batch, optional: true
  has_many   :mobile_notification_logs

  # Valiation
  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 255 }
  validate  :validate_schedule_at
  validate  :schedule_date_cannot_be_in_the_past

  # Enum
  enum platform: MobileToken.platforms
  enum status: {
    pending: 1,
    delivered: 2
  }

  # Instant method
  def build_content
    { notification: { title:, body: }, apns: { payload: { aps: { "content-available": 1 } } }, android: { "priority": "high" } }
  end

  def removeable?
    schedule_date.present? && schedule_date > Time.zone.now
  end

  # Class method
  def self.filter(params = {})
    scope = all
    scope = scope.where("title LIKE ?", "%#{params[:title]}%") if params[:title].present?
    scope = scope.where("schedule_date BETWEEN ? AND ?", DateTime.parse(params[:start_date]).beginning_of_day, DateTime.parse(params[:end_date]).end_of_day) if params[:start_date].present? && params[:end_date].present?
    scope
  end

  private
    def validate_schedule_at
      return true if schedule_at.blank?

      errors.add :schedule_date, "is invalid format" unless convert_schedule_at
    end

    def convert_schedule_at
      self.schedule_date = Time.zone.parse(schedule_at.to_s)
    rescue ArgumentError
      false
    end

    def schedule_date_cannot_be_in_the_past
      if schedule_date.present? && schedule_date < Time.zone.now + 5.minutes
        errors.add(:schedule_date, "must be bigger than current time at least 5 minutes")
      end
    end
end
