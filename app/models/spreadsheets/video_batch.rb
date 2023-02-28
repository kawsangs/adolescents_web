module Spreadsheets
  class VideoBatch < Base
    attr_reader :batch

    def initialize(user)
      @batch = user.video_batches.new
      @videos_attributes = []
    end

    def import(file)
      super

      batch.videos_attributes = @videos_attributes
      batch.attributes = batch.attributes.merge(batch_params(file))
      batch
    end

    def process(row)
      @videos_attributes.push({
        name: row["name"],
        url: row["url"],
        video_author_attributes: { name: row["author"] },
        video_category_attributes: { name: row["category"] }
      })
    end

    private
      def batch_params(file)
        valid_videos = batch.videos.select { |s| s.valid? }
        {
          total_count: batch.videos.length,
          valid_count: valid_videos.length,
          filename: file.original_filename
        }
      end
  end
end
