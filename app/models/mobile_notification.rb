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
#  topic_id                     :uuid
#
class MobileNotification < ApplicationRecord
  include ItemableConcern
  include MobileNotifications::SchedulableConcern

  # Enum
  enum platform: MobileToken.platforms
  enum status: {
    pending: 1,
    delivered: 2
  }

  # Association
  belongs_to :creator, foreign_key: :creator_id, class_name: "User"
  belongs_to :survey_form, foreign_key: :topic_id, class_name: "Topics::SurveyForm", optional: true
  has_many   :mobile_notification_logs

  # Valiation
  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 255 }

  # Callback
  after_create :published_survey_form, if: -> { topic_id.present? }

  # Delegation
  delegate :name, to: :survey_form, prefix: true, allow_nil: true

  # Instant method
  def build_content
    {
      data: { payload: { topic_id:, mobile_notification_id: id }.to_json },
      notification: { title:, body: },
      apns: {
        payload: {
          aps: {
            "content-available": 1,
            "sound": "youthhealth.aiff"
          }
        }
      },
      android: {
        "priority": "high",
        "notification": {
          "sound": "youthhealth",
          "channelId": "youthhealth"
        }
      }
    }
  end

  # Class method
  def self.filter(params = {})
    scope = all
    scope = scope.where("title LIKE ?", "%#{params[:title]}%") if params[:title].present?
    scope = scope.where("schedule_date BETWEEN ? AND ?", DateTime.parse(params[:start_date]).beginning_of_day, DateTime.parse(params[:end_date]).end_of_day) if params[:start_date].present? && params[:end_date].present?
    scope = scope.where(topic_id: params[:topic_id]) if params[:topic_id].present?
    scope
  end

  private
    def published_survey_form
      survey_form.publish unless survey_form.published?
    end
end
