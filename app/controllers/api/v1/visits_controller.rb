module Api
  module V1
    class VisitsController < ApiController
      def create
        visit = Visit.new(visit_params)

        if visit.save
          render json: visit, status: :created
        else
          render json: { error: visit.errors }, status: :unprocessable_entity
        end
      end

      private
        def visit_params
          params.require(:visit).permit(
            :device_id, :visit_date,
            page_attributes: [:code, :name, :parent_code],
            platform_attributes: [:name]
          )
        end
    end
  end
end
