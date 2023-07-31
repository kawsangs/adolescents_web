class VideoTagsController < ApplicationController
  include Tags::TaggablesConcern

  private
    def query_tags
      authorize Video.tag_counts(filter_params).includes(:videos)
    end
end
