class FacilitiesController < ApplicationController
  before_action :set_facility, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @facilities = pagy(authorize Facility.filter(filter_params).includes(:services))
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
        :name, :address, :latitude, :longitude, :tels, :emails, :websites,
        :facebook_pages, :telegram_username, :description,
        working_days_attributes: [ :id, :day, :open, :_destroy,
          working_hours_attributes: [:id, :open_at, :close_at, :_destroy]
        ],
        services_attributes: [:name, :_destroy]
      )
    end

    def filter_params
      params.permit(:name, :batch_code)
    end

    def set_facility
      @facility = authorize Facility.find(params[:id])
    end
end
