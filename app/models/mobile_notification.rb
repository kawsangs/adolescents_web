# == Schema Information
#
# Table name: mobile_notifications
#
#  id            :bigint           not null, primary key
#  title         :string
#  body          :text
#  success_count :integer
#  failure_count :integer
#  creator_id    :integer
#  app_versions  :string           default([]), is an Array
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  platform      :integer
#
class MobileNotification < ApplicationRecord
  validates :body, presence: true
  belongs_to :creator, foreign_key: :creator_id, class_name: "User"

  after_commit :push_notification_async, on: [:create]

  enum platform: MobileToken.platforms

  def push_notification_async
    MobileNotificationJob.perform_async(id)
  end

  def build_content
    { notification: { title:, body: } }
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
end
