module Spreadsheets
  class FacilityBatch < Base
    attr_reader :batch

    def initialize(user)
      @batch = user.facility_batches.new
      @facilities_attributes = []
    end

    def import(file)
      super

      batch.facilities_attributes = @facilities_attributes
      batch.attributes = batch.attributes.merge(batch_params(file))
      batch
    end

    def process(row)
      commune = Pumi::Commune.find_by_id(row["commune_id"])

      @facilities_attributes.push({
        name: row["name"],
        province_id: commune.try(:province_id),
        district_id: commune.try(:district_id),
        commune_id: commune.try(:id),
        street: row["street"],
        house_number: row["house_number"],
        tels: string_to_array(row["tels"]),
        emails: string_to_array(row["emails"]),
        websites: string_to_array(row["websites"]),
        facebook_pages: string_to_array(row["facebook_pages"]),
        telegram_username: row["telegram_username"],
        description: row["description"],
        working_days_attributes: working_days_attributes(row),
        latitude: row["latitude"],
        longitude: row["longitude"],
        services_attributes: services_attributes(row)
      })
    end

    private
      def batch_params(file)
        valid_facilities = batch.facilities.select { |s| s.valid? }
        {
          total_count: batch.facilities.length,
          valid_count: valid_facilities.length,
          province_count: valid_facilities.pluck(:province_id).uniq.length,
          filename: file.original_filename
        }
      end

      def working_days_attributes(row)
        days = []

        WorkingDay.days.keys.each do |day|
          open_at = row["#{day.titleize}_open_at"]
          close_at = row["#{day.titleize}_close_at"]

          next unless open_at.present? && close_at.present?

          days.push({ day:, open: true, working_hours_attributes: [ { open_at:, close_at: } ] })
        end

        days
      end

      def services_attributes(row)
        services = {}

        string_to_array(row["services"]).each_with_index do |name, index|
          services[index.to_s] = { name: }
        end

        services
      end
  end
end
