module Api
  module V1
    class VisitsController < ApiController
      def create
        VisitJob.perform_async(visit_params)

        head :created
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
