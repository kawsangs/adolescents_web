class AppUsersController < ApplicationController
  helper_method :filter_params

  def index
    respond_to do |format|
      format.html {
        @pagy, @app_users = pagy(authorize app_user_query)
        @total_uniq_devices = AppUser.filter(filter_params).pluck(:device_id).uniq.count
      }

      format.xlsx {
        @app_users = authorize app_user_query

        if @app_users.length > Settings.max_download_record
          flash[:alert] = t("shared.file_size_is_too_big", max_record: Settings.max_download_record)
          redirect_to app_users_url
        else
          render xlsx: "index", filename: "app_users_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.xlsx"
        end
      }
    end
  end

  private
    def filter_params
      params.permit(:start_date, :end_date, :start_age, :end_age, :platform,
        province_ids: [], genders: [], characteristic_ids: []
      )
    end

    def app_user_query
      AppUser.filter(filter_params)
             .includes(:visits, :characteristics)
             .order(sort_column + " " + sort_direction)
    end
end
