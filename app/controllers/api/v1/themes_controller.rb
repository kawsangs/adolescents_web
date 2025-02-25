module Api
  module V1
    class ThemesController < ApiController
      before_action :set_and_validate_updated_at_filter, only: :index

      def index
        pagy, themes = pagy(Theme.filter(updated_at: @updated_at).published.includes(:assets))

        render json: {
          pagy: pagy.vars,
          themes: ActiveModel::Serializer::CollectionSerializer.new(themes, serializer: ThemeSerializer)
        }, status: :ok
      end

      def show
        theme = Theme.published.find(params[:id])
        render json: theme, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Theme not found" }, status: :not_found
      end

      private
        def set_and_validate_updated_at_filter
          @updated_at = params[:updated_at]&.to_i
          if @updated_at.nil? || @updated_at <= 0
            render json: { error: "updated_at must be a valid epoch timestamp" }, status: :bad_request
            nil
          end
        end
    end
  end
end
