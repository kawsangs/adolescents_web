module Samples
  class Theme < Base
    def load
      csv = CSV.read(file_path("themes.csv"))
      csv.shift
      csv.each do |data|
        theme = ::Theme.find_or_initialize_by(name: data[0])

        theme.update(
          default: data[1],
          status: data[2],
          primary_color: data[3],
          secondary_color: data[4]
        )
      end
    end
  end
end
