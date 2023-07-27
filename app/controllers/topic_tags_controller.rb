class TopicTagsController < ApplicationController
  include Tags::TaggablesConcern

  private
    def query_tags
      authorize Topic.tag_counts(filter_params).includes(:topics)
    end
end
