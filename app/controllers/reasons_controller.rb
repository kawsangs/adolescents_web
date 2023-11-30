class ReasonsController < ApplicationController
  helper_method :filter_params
  before_action :authorize_reason, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html {
        @pagy, @reasons = pagy(query_reason)
      }

      format.json {
        @reasons = query_reason

        if @reasons.length > Settings.max_download_record
          flash[:alert] = t("shared.file_size_is_too_big", max_record: Settings.max_download_record)
          redirect_to reasons_url
        else
          render json: @reasons
        end
      }

      format.xlsx {
        @reasons = query_reason

        if @reasons.length > Settings.max_download_record
          flash[:alert] = t("shared.file_size_is_too_big", max_record: Settings.max_download_record)
          redirect_to reasons_url
        else
          render xlsx: "index", filename: "reason_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.xlsx"
        end
      }
    end
  end

  def new
    @reason = Reason.new
  end

  def create
    @reason = authorize Reason.new(reason_params)

    if @reason.save
      redirect_to reasons_url, notice: "Reason was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @reason.update(reason_params)
      redirect_to reasons_url, notice: "Reason was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @reason.destroy

    redirect_to reasons_url, notice: "Reason was successfully destroyed."
  end

  def sort
    Reason.update_order!(params[:ids])

    render json: { status: 201 }
  end

  private
    def filter_params
      params.permit(:name, :batch_code, reason_author: [], tag: [])
    end

    def reason_params
      params.require(:reason).permit(:name_km, :name_en)
    end

    def authorize_reason
      @reason = authorize Reason.find(params[:id])
    end

    def query_reason
      authorize Reason.filter(filter_params)
    end
end
