class AppUsersController < ApplicationController
  helper_method :filter_params

  def index
    respond_to do |format|
      format.html {
        @pagy, @app_users = pagy(authorize AppUser.filter(filter_params).includes(app_user_characteristics: :characteristic))
      }

      format.xlsx {
        @app_users = authorize authorize AppUser.filter(filter_params).includes(app_user_characteristics: :characteristic)

        if @app_users.length > Settings.max_download_visit_record
          flash[:alert] = t("shared.file_size_is_too_big")
          redirect_to app_users_url
        else
          render xlsx: "index", filename: "app_users_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.xlsx"
        end
      }
    end
  end

  private
    def filter_params
      params.permit(:start_date, :end_date, :start_age, :end_age,
        province_ids: [], genders: [], characteristic_ids: []
      )
    end
end
