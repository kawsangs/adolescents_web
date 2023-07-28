class ContactDirectoriesController < ApplicationController
  helper_method :filter_params

  def index
    respond_to do |format|
      format.html {
        @pagy, @directories = pagy(query_directories)
      }

      format.json {
        @directories = query_directories

        if @directories.length > Settings.max_download_record
          flash[:alert] = t("shared.file_size_is_too_big", max_record: Settings.max_download_record)
          redirect_to contact_directories_url
        else
          render json: @directories
        end
      }
    end
  end

  private
    def filter_params
      params.permit(:name)
    end

    def query_directories
      authorize ContactDirectory.filter(filter_params).includes(:contacts)
    end
end
