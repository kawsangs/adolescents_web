# frozen_string_literal: true

module Spreadsheets
  class Batches::ContactBatchSpreadsheet < Spreadsheets::Batches::BaseSpreadsheet
    private
      def batch_model
        ::Batches::ContactBatch
      end

      def assign_items(sheet, sheet_name)
        @items = sheet.parse(headers: true)[1..-1] if sheet_name.downcase == "contact_list"
      end

      def importing_items
        ids = @items.map { |r| r["id"] }
        items = Contact.where(id: ids).includes(:contact_directory)

        @items.map do |row|
          item = items.select { |f| f.id == row["id"] }.first || Contact.new

          batch.importing_items.new(itemable: Spreadsheets::Batches::ContactSpreadsheet.new(item).process(row))
        end
      end
  end
end
