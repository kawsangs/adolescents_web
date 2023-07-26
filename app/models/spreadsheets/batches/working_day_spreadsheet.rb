# frozen_string_literal: true

module Spreadsheets
  module Batches
    class WorkingDaySpreadsheet
      def initialize(day, row)
        @day = day
        @open_at = row["#{@day.titleize}_open_at"]
        @close_at = row["#{@day.titleize}_close_at"]
      end

      def process
        {
          day: @day,
          open: open_business?,
          working_hours_attributes: working_hours_attributes
        }
      end

      private
        def open_business?
          @open_at.present?
        end

        def working_hours_attributes
          return [] unless open_business?

          [{ open_at: @open_at, close_at: @close_at } ]
        end
    end
  end
end
