# frozen_string_literal: true

module Spreadsheets
  class Batches::VideoBatchSpreadsheet < Spreadsheets::Batches::BaseSpreadsheet
    private
      def batch_model
        ::Batches::VideoBatch
      end

      def importing_items
        ids = @items.map { |r| r["id"] }
        items = Video.where(id: ids).includes(:video_author, :video_category)

        @items.map do |row|
          item = items.select { |f| f.id == row["id"] }.first || Video.new

          batch.importing_items.new(itemable: Spreadsheets::Batches::VideoSpreadsheet.new(item).process(row))
        end
      end
  end
end
