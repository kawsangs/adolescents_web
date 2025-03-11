module Api
  module V1
    class ThemesController < ApiController
      def index
        pagy, themes = pagy(Theme.published.includes(:assets))

        render json: {
          pagy: pagy.vars,
          themes: ActiveModel::Serializer::CollectionSerializer.new(themes, serializer: ThemeSerializer)
        }
      end

      def show
        theme = Theme.published.find(params[:id])

        render json: theme
      end
    end
  end
end
