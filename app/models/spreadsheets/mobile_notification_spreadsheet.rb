module Spreadsheets
  class MobileNotificationSpreadsheet < Base
    attr_reader :batch

    def initialize(user)
      @batch = user.mobile_notification_batches.new
      @mobile_notifications_attributes = []
    end

    def import(file)
      super

      batch.mobile_notifications_attributes = @mobile_notifications_attributes
      batch.attributes = batch.attributes.merge(batch_params(file))
      batch
    end

    def process(row)
      platform = row["platform"].to_s.downcase

      @mobile_notifications_attributes.push({
        title: row["title"],
        body: row["body"],
        platform: (platform if MobileNotification.platforms.keys.include? platform),
        schedule_at: schedule_at(row["schedule_date"]),
        creator_id: @batch.user_id
      })
    end

    private
      def schedule_at(value, timezone="+0700")
        date = format_date(value)
        return value if value.nil? || date.nil?

        Time.new(date.year, date.month, date.day, date.hour, date.min, date.sec, timezone)
      end

      def format_date(date)
        DateTime.parse date.to_s rescue nil
      end

      def batch_params(file)
        valid_notifications = batch.mobile_notifications.select { |s| s.valid? }
        {
          total_count: batch.mobile_notifications.length,
          valid_count: valid_notifications.length,
          filename: file.original_filename
        }
      end
  end
end
