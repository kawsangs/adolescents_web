module Api
  module V1
    class AppUsersController < ApiController
      def create
        app_user = AppUser.new(app_user_params)

        if app_user.save
          render json: app_user, status: :created
        else
          render json: { errors: app_user.errors }, status: :unprocessable_entity
        end
      end

      def update
        app_user = AppUser.find(params[:id])

        if app_user.update(app_user_params)
          render json: app_user
        else
          render json: { errors: app_user.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        app_user = AppUser.find params[:id]

        if app_user.destroy_with_reason(reason_code)
          render json: { message: I18n.t("app_user.delete_info_success") }, status: :ok
        else
          render json: { errors: app_user.errors }, status: :unprocessable_entity
        end
      end

      private
        def app_user_params
          params.require(:app_user).permit(
            :uuid, :gender, :age, :province_id, :registered_at, :device_id, :platform,
            :occupation, :education_level,
            app_user_characteristics_attributes: [
              characteristic_attributes: [ :code ]
            ]
          )
        end

        def reason_code
          params[:reason_code] || params.require(:app_user).permit(reason_ids: [])["reason_ids"].try(:first)
        end
    end
  end
end
