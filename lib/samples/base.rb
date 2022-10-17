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

      def get_audio(filename)
        return unless filename.present?

        audio = audios.select { |file| file.split("/").last.split(".mp3").first == "#{filename.split('.mp3').first}" }.first
        Pathname.new(audio).open if audio.present?
      end

      def audios
        @audios ||= Dir.glob(Rails.root.join("lib", "samples", "assets", "audios", "**", "**", "**", "**"))
      end
  end
end
