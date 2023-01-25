class FacilitiesController < ApplicationController
  helper_method :filter_params
  before_action :set_facility, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html {
        @pagy, @facilities = pagy(query_facility)
      }

      format.json {
        @facilities = query_facility

        if @facilities.length > Settings.max_download_record
          flash[:alert] = t("shared.file_size_is_too_big", max_record: Settings.max_download_record)
          redirect_to facilities_url
        else
          send_data ActiveModelSerializers::SerializableResource.new(@facilities).to_json, type: :json, disposition: "attachment", filename: "facilities_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.json"
        end
      }

      format.xlsx {
        @facilities = query_facility

        if @facilities.length > Settings.max_download_record
          flash[:alert] = t("shared.file_size_is_too_big", max_record: Settings.max_download_record)
          redirect_to facilities_url
        else
          render xlsx: "index", filename: "facility_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.xlsx"
        end
      }
    end
  end

  def show
  end

  def new
    @facility = authorize Facility.new
  end

  def create
    @facility = authorize Facility.new(facility_params)

    if @facility.save
      redirect_to facilities_url, notice: "Facility was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @facility.update(facility_params)
      redirect_to facilities_url, notice: "Facility was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @facility.destroy

    redirect_to facilities_url, notice: "Facility was successfully destroyed."
  end

  private
    def facility_params
      params.require(:facility).permit(
        :name, :province_id, :district_id, :commune_id, :street,
        :house_number, :latitude, :longitude, :tels, :emails, :websites,
        :facebook_pages, :telegram_username, :description, :tag_list,
        working_days_attributes: [ :id, :day, :open, :_destroy,
          working_hours_attributes: [:id, :open_at, :close_at, :_destroy]
        ],
        services_attributes: [:name, :_destroy]
      )
    end

    def filter_params
      params.permit(:name, :batch_code, tag: [])
    end

    def set_facility
      @facility = authorize Facility.find(params[:id])
    end

    def query_facility
      authorize Facility.filter(filter_params).includes(:services, :tags, working_days: :working_hours)
    end
end
