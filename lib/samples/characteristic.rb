require "csv"

module Samples
  class Characteristic < Base
    def load
      csv = CSV.read(file_path("characteristics.csv"))
      csv.shift

      csv.each do |row|
        upsert_characteristic(row)
      end
    end

    private
      def upsert_characteristic(row)
        characteristic = ::Characteristic.find_or_initialize_by(code: row[0])

        characteristic.update({ name_en: row[1], name_km: row[2] })
      end
  end
end
