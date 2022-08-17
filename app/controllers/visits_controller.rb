class VisitsController < ApplicationController
  def index
    respond_to do |format|
      format.html {
        @pagy, @visits = pagy(authorize Visit.includes(:page))
      }

      format.xlsx {
        @visits = authorize Visit.includes(:page)

        if @visits.length > Settings.max_download_visit_record
          flash[:alert] = t("shared.file_size_is_too_big")
          redirect_to visits_url
        else
          render xlsx: "index", filename: "visits_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.xlsx"
        end
      }
    end
  end
end
