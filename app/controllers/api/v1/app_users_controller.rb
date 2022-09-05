module Api
  module V1
    class AppUsersController < ApiController
      def create
        app_user = AppUser.new(app_user_params)

        if app_user.save
          render json: app_user, status: :created
        else
          render json: { errors: app.app_user.errors }, status: :unprocessable_entity
        end
      end

      private
        def app_user_params
          params.require(:app_user).permit(
            :gender, :age, :province_id, :registered_at, :device_id,
            app_user_characteristics_attributes: [
              characteristic_attributes: [ :name ]
            ]
          )
        end
    end
  end
end
