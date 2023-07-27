class CategoryTagsController < ApplicationController
  include Tags::TaggablesConcern

  private
    def query_tags
      authorize Category.tag_counts(filter_params).includes(:categories)
    end
end
