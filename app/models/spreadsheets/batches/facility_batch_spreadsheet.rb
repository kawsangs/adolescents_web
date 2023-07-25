# frozen_string_literal: true

module Spreadsheets
  class Batches::FacilityBatchSpreadsheet < Spreadsheets::Batches::BaseSpreadsheet
    private
      def batch_model
        ::Batches::FacilityBatch
      end

      def importing_items
        ids = @items.map { |r| r["id"] }
        items = Facility.where(id: ids).includes(:tags, :services, working_days: :working_hours)

        @items.map do |row|
          item = items.select { |f| f.id == row["id"] }.first || Facility.new

          batch.importing_items.new(itemable: Spreadsheets::Batches::FacilitySpreadsheet.new(item).process(row))
        end
      end
  end
end
