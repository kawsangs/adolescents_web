class MobileNotificationImportersController < ApplicationController
  include Batches::ItemableImportersConcern

  private
    def batch_type
      "MobileNotificationBatch"
    end

    def redirect_success_url
      mobile_notifications_url
    end

    def redirect_error_url
      new_mobile_notification_importer_url
    end

    def itemable_attributes
      [:title, :body, :platform, :schedule_date, :creator_id]
    end
end
