# frozen_string_literal: true

module Spreadsheets
  module Batches
    class CategorySpreadsheet
      include ::Spreadsheets::AttachmentSpreadsheet

      attr_reader :category

      def initialize(category)
        @category = category
        @sources = sources
      end

      def process(row, zipfile)
        category.attributes = {
          code: row["code"],
          name: row["name"],
          image: find_attachment(row["image"], zipfile),
          audio: find_attachment(row["audio"], zipfile),
          description: row["description"],
          parent_id: (Category.find_by(code: row["parent_code"]).try(:id) if row["parent_code"].present?)
        }

        category
      end
    end
  end
end
