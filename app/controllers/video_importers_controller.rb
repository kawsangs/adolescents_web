class VideoImportersController < ApplicationController
  include Batches::ItemableImportersConcern

  private
    def batch_type
      "VideoBatch"
    end

    def redirect_success_url
      videos_url
    end

    def redirect_error_url
      new_video_importer_url
    end

    def itemable_attributes
      [
        :id, :name, :url,
        video_author_attributes: [:name],
        video_category_attributes: [:name]
      ]
    end
end
