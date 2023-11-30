# frozen_string_literal: true

module Spreadsheets
  module Batches
    class ReasonSpreadsheet
      attr_reader :reason

      def initialize(reason)
        @reason = reason
      end

      def process(row)
        reason.attributes = {
          code: row["code"],
          name_km: row["name_km"],
          name_en: row["name_en"]
        }

        reason
      end
    end
  end
end
