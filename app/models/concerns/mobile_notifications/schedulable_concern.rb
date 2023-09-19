# frozen_string_literal: true

module MobileNotifications::SchedulableConcern
  extend ActiveSupport::Concern

  included do
    # to support excel import
    attr_accessor :schedule_at

    # Validation
    validate  :validate_schedule_at
    validate  :schedule_date_cannot_be_in_the_past

    # Callback
    before_create  :set_schedule_date
    before_destroy :validate_schedule_date

    after_create   :push_notification_async
    after_destroy  :delete_schedule

    def push_notification_async
      self.update(job_id: push_notification)
    end

    def removeable?
      schedule_date > Time.zone.now
    end

    private
      def delete_schedule
        schedule = Sidekiq::ScheduledSet.new.find_job(job_id)
        schedule.try(:delete)
      end

      def push_notification
        MobileNotificationJob.perform_at(schedule_date, id)
      end

      def validate_schedule_date
        if !removeable?
          errors.add :base, "Cannot delete past schedule date notification!"
          throw(:abort)
        end
      end

      def set_schedule_date
        self.schedule_date ||= Time.zone.now
      end

      def validate_schedule_at
        if schedule_at.present? && !assign_schedule_date
          errors.add :schedule_date, "is invalid format"
          throw(:abort)
        end
      end

      def assign_schedule_date
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
end
