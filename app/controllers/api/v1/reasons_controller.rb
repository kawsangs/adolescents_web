# frozen_string_literal: true

module Api
  module V1
    class ReasonsController < ::Api::V1::ApiController
      def index
        pagy, reasons = pagy(Reason.filter(filter_params).with_deleted)

        render json: {
          pagy: pagy.vars,
          reasons: ActiveModel::Serializer::CollectionSerializer.new(reasons, serializer: ReasonSerializer)
        }
      end

      private
        def filter_params
          params.permit(:updated_at)
        end
    end
  end
end
