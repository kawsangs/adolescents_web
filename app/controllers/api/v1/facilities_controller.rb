module Api
  module V1
    class FacilitiesController < ApiController
      def index
        @facilities = Facility.all

        render json: @facilities
      end
    end
  end
end
