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
          name: row["title"],
          url: row["url"],
          tag_list: row["category"],
          video_author_attributes: { name: row["author"] }
        }

        video
      end
    end
  end
end
