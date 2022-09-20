require "csv"

module Samples
  class Location < Base
    def load
      csv = CSV.read(file_path("locations.csv"))
      csv.shift
      csv.each do |data|
        loc = ::Location.find_or_initialize_by(id: data[0])
        loc.update(
          name_en: data[1],
          name_km: data[2],
          kind: data[3],
          parent_id: data[4],
          latitude: data[5],
          longitude: data[6]
        )
      end
    end
  end
end
