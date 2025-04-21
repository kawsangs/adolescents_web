module Api
  module V1
    class ThemeUsagesController < ApiController
      def create
        theme_usage = ThemeUsage.new(theme_usage_params)

        if theme_usage.save
          render json: theme_usage, status: :created
        else
          render json: { errors: theme_usage.errors }, status: :unprocessable_entity
        end
      end

      private
        def theme_usage_params
          params.require(:theme_usage).permit(
            :app_user_id, :theme_id, :applied_at
          )
        end
    end
  end
end
