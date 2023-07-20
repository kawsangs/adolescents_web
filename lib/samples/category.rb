module Samples
  class Category < Base
    def load
      csv = CSV.read(file_path("category.csv"))
      csv.shift

      csv.each do |row|
        upsert_category(row)
      end
    end

    private
      def upsert_category(row)
        category = ::Category.find_or_initialize_by(code: row[0])
        category.update({ name: row[1] })
      end
  end
end
