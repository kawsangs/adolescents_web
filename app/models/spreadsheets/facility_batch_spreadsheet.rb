module Spreadsheets
  class FacilityBatchSpreadsheet < Base
    attr_reader :batch

    def initialize(user)
      @batch = user.facility_batches.new
      @rows = []
    end

    def import(file)
      super

      batch.importing_facilities = importing_facilities
      batch.attributes = batch.attributes.merge(batch_params(file))
      batch
    end

    def process(row)
      @rows.push(row)
    end

    private
      def batch_params(file)
        facilities = batch.importing_facilities
                          .select { |im| im.facility.valid? }
                          .map { |im| im.facility }
        {
          total_count: batch.importing_facilities.length,
          valid_count: facilities.length,
          new_count: facilities.select { |f| f.new_record? }.length,
          province_count: facilities.pluck(:province_id).uniq.length,
          reference: file
        }
      end

      def importing_facilities
        ids = @rows.map { |r| r["id"] }
        facilities = Facility.where(id: ids).includes(:tags, :services, working_days: :working_hours)

        @rows.map do |row|
          facility = facilities.select { |f| f.id == row["id"] }.first || Facility.new

          batch.importing_facilities.new(facility: Spreadsheets::FacilityBatches::FacilitySpreadsheet.new(facility).process(row))
        end
      end
  end
end
