# frozen_string_literal: true

module Spreadsheets
  module Batches
    class VideoSpreadsheet
      attr_reader :video

      def initialize(video)
        @video = video
      end

      def process(row)
        video.attributes = {
          name: row["name"],
          url: row["url"],
          video_author_attributes: { name: row["author"] },
          video_category_attributes: { name: row["category"] }
        }

        video
      end
    end
  end
end
