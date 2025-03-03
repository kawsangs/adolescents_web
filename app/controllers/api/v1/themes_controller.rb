module Api
  module V1
    class ThemesController < ApiController
      def index
        pagy, themes = pagy(Theme.actives.includes(:assets))

        render json: {
          pagy: pagy.vars,
          themes: ActiveModel::Serializer::CollectionSerializer.new(themes, serializer: ThemeSerializer)
        }
      end

      def show
        theme = Theme.actives.find(params[:id])

        render json: theme
      end
    end
  end
end
