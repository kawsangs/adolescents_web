module Api
  module V1
    class FacilitiesController < ApiController
      def index
        pagy, facilities = pagy(Facility.all)

        render json: {
          pagy: pagy.vars,
          facilities: ActiveModel::Serializer::CollectionSerializer.new(facilities, serializer: FacilitySerializer)
        }
      end
    end
  end
end
