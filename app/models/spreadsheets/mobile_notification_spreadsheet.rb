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
        schedule_date: row["schedule_date"],
        creator_id: @batch.user_id
      })
    end

    private
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
