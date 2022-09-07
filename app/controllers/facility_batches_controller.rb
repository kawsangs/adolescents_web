class FacilityBatchesController < ApplicationController
  before_action :set_facility_batch, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @facility_batches = pagy(authorize FacilityBatch.filter(filter_params).order(updated_at: :desc))
  end

  def show
  end

  def new
    @facility_batch = authorize FacilityBatch.new
  end

  def create
    authorize FacilityBatch, :create?

    if file = params[:facility_batch][:file].presence
      @facility_batch = Spreadsheets::FacilityBatch.new(current_user).import(file)

      render :import_confirm, status: :see_other
    else

      create_facility_batch
    end
  end

  def destroy
    @facility_batch.destroy

    respond_to do |format|
      format.html { redirect_to facility_batches_url, notice: "Facility batch was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_facility_batch
      @facility_batch = authorize FacilityBatch.find_by(code: params[:code])
    end

    def create_facility_batch
      @facility_batch = FacilityBatch.new(facility_batch_params)

      if @facility_batch.save
        redirect_to facility_batch_url(@facility_batch.code), notice: "Facility batch was successfully imported."
      else
        render :import_confirm
      end
    end

    def facility_batch_params
      params.require(:facility_batch).permit(
        :total_count, :valid_count, :province_count, :filename,
        facilities_attributes: [
          :name, :address, :telegram_username, :description,
          :latitude, :longitude, :_destroy,
          tels: [], emails: [], websites: [], facebook_pages: [],
          working_days_attributes: [
            :day, :open,
            working_hours_attributes: [
              :open_at, :close_at
            ]
          ]

        ]
      ).merge({
        user_id: current_user.id
      })
    end

    def filter_params
      params.permit(:keyword)
    end
end
