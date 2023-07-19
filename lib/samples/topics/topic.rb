module Samples
  module Topics
    class Topic < ::Samples::Base
      def load(rows)
        rows[1..-1].each do |row|
          topic = ::Topic.find_or_initialize_by(code: row["code"])
          topic.update(
            name_km: row["name"],
            name_en: row["name"],
            audio: get_audio(row["audio"])
          )
        end
      end
    end
  end
end
