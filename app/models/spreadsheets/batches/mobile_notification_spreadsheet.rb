# frozen_string_literal: true

module Spreadsheets
  module Batches
    class MobileNotificationSpreadsheet
      attr_reader :mobile_notification

      def initialize(mobile_notification, user)
        @user = user
        @mobile_notification = mobile_notification
      end

      def process(row)
        platform = row["platform"].to_s.downcase

        mobile_notification.attributes = {
          title: row["title"],
          body: row["body"],
          platform: (platform if MobileNotification.platforms.keys.include? platform),
          schedule_at: schedule_at(row["schedule_date"]),
          creator_id: @user.id
        }

        mobile_notification
      end

      private
        def schedule_at(value, timezone = "+0700")
          date = format_date(value)
          return value if value.nil? || date.nil?

          Time.new(date.year, date.month, date.day, date.hour, date.min, date.sec, timezone)
        end

        def format_date(date)
          DateTime.parse date.to_s rescue nil
        end
    end
  end
end
