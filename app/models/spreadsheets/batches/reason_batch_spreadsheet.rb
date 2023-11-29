# frozen_string_literal: true

module Spreadsheets
  class Batches::ReasonBatchSpreadsheet < Spreadsheets::Batches::BaseSpreadsheet
    private
      def batch_model
        ::Batches::ReasonBatch
      end

      def importing_items
        codes = @items.map { |r| r["code"] }
        items = Reason.where(code: codes)

        @items.map do |row|
          item = items.select { |f| f.code == row["code"] }.first || Reason.new

          batch.importing_items.new(itemable: Spreadsheets::Batches::ReasonSpreadsheet.new(item).process(row))
        end
      end
  end
end
