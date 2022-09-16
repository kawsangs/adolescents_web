module Api
  module V1
    class VisitsController < ApiController
      def create
        VisitJob.perform_async(visit_params.as_json)

        head :created
      end

      private
        def visit_params
          params.require(:visit).permit(
            :app_user_id, :visit_date, :pageable_id, :pageable_type,
            page_attributes: [:code, :name, :parent_code],
            platform_attributes: [:name]
          )
        end
    end
  end
end
