# frozen_string_literal: true

module Spreadsheets
  module Batches
    class CategorySpreadsheet
      include ::Spreadsheets::AttachmentSpreadsheet

      attr_reader :category

      def initialize(category, sources)
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
          parent_id: (Category.find_by(code: row["parent_code"]).try(:id) if row["parent_code"].present?),
          tag_list: row["tag_list"]
        }

        category.content_sources_attributes = old_sources_for_removing.concat(new_sources_for_creating)
        category
      end

      private
        def old_sources_for_removing
          return [] if category.new_record?

          category.content_sources.map do |cs|
            { id: cs.id, _destroy: true }
          end
        end

        def new_sources_for_creating
          sources = @sources.select { |s| s["category_code"] == category.code }
          sources.map do |row|
            { name: row["name"], url: row["url"] }
          end
        end
    end
  end
end
