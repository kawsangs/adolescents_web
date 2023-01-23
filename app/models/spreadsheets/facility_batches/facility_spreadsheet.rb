module Spreadsheets
  class FacilityBatches::FacilitySpreadsheet
    attr_reader :facility

    def initialize(facility)
      @facility = facility
    end

    def process(row)
      commune = Pumi::Commune.find_by_id(row["commune_id"])

      facility.attributes = {
        name: row["name"],
        tag_list: row["tag_list"],
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
      }

      facility
    end

    private
      def working_days_attributes(row)
        days = []
        days = facility.working_days.map { |wd| { id: wd.id, _destroy: 1 } } if !facility.new_record?

        WorkingDay.days.keys.each do |day|
          open_at = row["#{day.titleize}_open_at"]
          close_at = row["#{day.titleize}_close_at"]

          if open_at.to_i == 24
            days.push({ day:, open: true, working_hours_attributes: [ { open_at: } ] })
          else
            days.push({ day:, open: true, working_hours_attributes: [ { open_at:, close_at: } ] }) if open_at.present? && close_at.present?
          end
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

      def string_to_array(str)
        str.to_s.split(",").map { |st| st.strip }
      end
  end
end
