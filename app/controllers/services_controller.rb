class ServicesController < ApplicationController
  helper_method :filter_params
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @services = pagy(authorize Service.filter(filter_params).order(updated_at: :desc))

    respond_to do |format|
      format.html {
        @pagy, @services = pagy(authorize Service.filter(filter_params).order(updated_at: :desc))
      }

      format.json {
        @services = authorize Service.filter(filter_params).order(updated_at: :desc)

        if @services.length > Settings.max_download_visit_record
          flash[:alert] = t("shared.file_size_is_too_big")
          redirect_to services_url
        else
          send_data ActiveModelSerializers::SerializableResource.new(@services).to_json, type: :json, disposition: "attachment", filename: "services_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.json"
        end
      }
    end
  end

  def show
  end

  def new
    @service = authorize Service.new
  end

  def create
    @service = authorize Service.new(service_params)

    if @service.save
      redirect_to services_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @service.update(service_params)
      redirect_to services_url
    else
      render :edit
    end
  end

  def destroy
    @service.destroy

    redirect_to services_url
  end

  private
    def filter_params
      params.permit(:name)
    end

    def service_params
      params.require(:service).permit(:name)
    end

    def set_service
      @service = authorize Service.find(params[:id])
    end
end
