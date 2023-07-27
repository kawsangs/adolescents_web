class FacilityTagsController < ApplicationController
  include Tags::TaggablesConcern

  private
    def query_tags
      authorize Facility.tag_counts(filter_params).includes(:facilities)
    end
end
