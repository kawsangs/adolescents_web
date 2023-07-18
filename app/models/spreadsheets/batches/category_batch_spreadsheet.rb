# frozen_string_literal: true

module Spreadsheets
  class Batches::CategoryBatchSpreadsheet < Spreadsheets::Batches::BaseWithZipfileSpreadsheet
    private
      def batch_model
        ::Batches::CategoryBatch
      end

      def assign_items(sheet, sheet_name)
        @items = sheet.parse(headers: true)[1..-1] if sheet_name.to_s.downcase == "category"
        # @sources = sheet.parse(headers: true)[1..-1] if sheet_name.to_s.downcase == "source"
      end

      def importing_items(zipfile)
        codes = @items.map { |r| r["code"] }
        items = Category.where(code: codes)

        @items.map do |row|
          item = items.select { |f| f.code == row["code"] }.first || Category.new

          batch.importing_items.new(itemable: Spreadsheets::Batches::CategorySpreadsheet.new(item).process(row, zipfile))
        end
      end
  end
end
