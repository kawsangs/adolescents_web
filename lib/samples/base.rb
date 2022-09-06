# frozen_string_literal: true

module Samples
  class Base
    def load
      raise "Implement in sub class"
    end

    private
      def file_path(file_name)
        path = Rails.root.join("lib", "samples", "assets", "csv", file_name).to_s

        return puts "Fail to import data. could not find #{path}" unless File.file?(path)

        path
      end
  end
end
