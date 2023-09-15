# frozen_string_literal: true

module Spreadsheets
  class Batches::MobileNotificationBatchSpreadsheet < Spreadsheets::Batches::BaseSpreadsheet
    private
      def batch_model
        ::Batches::MobileNotificationBatch
      end

      def importing_items
        @items.map do |row|
          item = MobileNotification.new

          batch.importing_items.new(itemable: Spreadsheets::Batches::MobileNotificationSpreadsheet.new(item, user).process(row))
        end
      end
  end
end
