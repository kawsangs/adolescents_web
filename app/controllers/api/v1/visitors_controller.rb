module Api
  module V1
    class VisitorsController < ApiController
      def create
        visitor = Visitor.new(visitor_params)

        if visitor.save
          render json: visitor, status: :created
        else
          render json: { error: visitor.errors }, status: :unprocessable_entity
        end
      end

      private
        def visitor_params
          params.require(:visitor).permit(
            :device_id, :visit_date,
            page_attributes: [:code, :name, :parent_code],
            platform_attributes: [:name]
          )
        end
    end
  end
end
