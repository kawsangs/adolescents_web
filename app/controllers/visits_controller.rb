class VisitsController < ApplicationController
  helper_method :filter_params

  def index
    respond_to do |format|
      format.html {
        @pagy, @visits = pagy(authorize Visit.filter(filter_params).order(created_at: :desc).includes(:page, :app_user))
      }

      format.xlsx {
        @visits = authorize Visit.filter(filter_params).includes(:page, :app_user)

        if @visits.length > Settings.max_download_visit_record
          flash[:alert] = t("shared.file_size_is_too_big")
          redirect_to visits_url
        else
          render xlsx: "index", filename: "visits_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.xlsx"
        end
      }
    end
  end

  private
    def filter_params
      params.permit(:start_date, :end_date, :platform, page_ids: [])
    end
end
