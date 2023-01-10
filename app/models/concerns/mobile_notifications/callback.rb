# frozen_string_literal: true

module MobileNotifications::Callback
  extend ActiveSupport::Concern

  included do
    after_commit :push_notification_async, on: [:create]
    after_destroy :delete_schedule

    def push_notification_async
      self.update(job_id: push_notification)
    end

    private
      def delete_schedule
        schedule = Sidekiq::ScheduledSet.new.find_job(job_id)
        schedule.try(:delete)
      end

      def push_notification
        return MobileNotificationJob.perform_async(id) if schedule_date.blank?

        MobileNotificationJob.perform_at(schedule_date, id)
      end
  end
end
