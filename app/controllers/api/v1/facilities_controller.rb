module Api
  module V1
    class FacilitiesController < ApiController
      def index
        pagy, facilities = pagy(Facility.all)

        render json: { pagy: pagy.vars, facilities: facilities }
      end
    end
  end
end
