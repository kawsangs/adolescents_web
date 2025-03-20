module Api
  module V1
    class ThemesController < ApiController
      before_action :validate_params, only: :index

      def index
        pagy, themes = pagy(Theme.from_date(params[:from]).published.includes(:assets), items: 10)

        render json: {
          pagy: pagy.vars,
          themes: ActiveModel::Serializer::CollectionSerializer.new(themes, serializer: ThemeSerializer)
        }, status: :ok
      end

      def show
        theme = Theme.published.find(params[:id])
        render json: theme, status: :ok
      rescue ActiveRecord::RecordNotFound
        render_error("Theme not found", :not_found)
      end

      private
        def validate_params
          return unless invalid_from_date_filter?

          render_error("from param must be a valid epoch timestamp", :bad_request)
          nil
        end

        def invalid_from_date_filter?
          params[:from].present? && !valid_timestamp?(params[:from])
        end

        def valid_timestamp?(timestamp)
          return false unless timestamp.match?(/\A\d+\z/)

          seconds = timestamp.to_i
          # PostgreSQL timestamp range: 4713 BC to 294276 AD
          # Approx Unix epoch range: -2^31 to 2^31 seconds, but we'll use a practical limit
          seconds > 0 && seconds <= 293295235200 && valid_time_conversion?(seconds)
        end

        def valid_time_conversion?(timestamp)
          Time.at(timestamp.to_i).to_date
          true
        rescue ArgumentError
          false
        end
    end
  end
end
