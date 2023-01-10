class MobileNotificationImportersController < ApplicationController
  before_action :set_mobile_notification_batch, only: [:edit, :update, :destroy]

  def index
    @pagy, @mobile_notification_batches = pagy(authorize MobileNotificationBatch.filter(filter_params).order(updated_at: :desc).includes(:mobile_notifications))
  end

  def new
    @mobile_notification_batch = authorize MobileNotificationBatch.new
  end

  def create
    authorize MobileNotificationBatch, :create?

    if file = params[:mobile_notification_batch][:file].presence
      @mobile_notification_batch = Spreadsheets::MobileNotificationSpreadsheet.new(current_user).import(file)

      render :import_confirm, status: :see_other
    else
      create_mobile_notification_batch
    end
  end

  def destroy
    @mobile_notification_batch.destroy

    respond_to do |format|
      format.html { redirect_to mobile_notification_batches_url, notice: "Notification batch was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_mobile_notification_batch
      @mobile_notification_batch = authorize MobileNotificationBatch.find_by(code: params[:code])
    end

    def create_mobile_notification_batch
      @mobile_notification_batch = MobileNotificationBatch.new(mobile_notification_batch_params)

      if @mobile_notification_batch.save
        redirect_to mobile_notifications_url, notice: "Notifications was successfully imported."
      else
        render :import_confirm
      end
    end

    def mobile_notification_batch_params
      params.require(:mobile_notification_batch).permit(
        :total_count, :valid_count, :filename,
        mobile_notifications_attributes: [
          :title, :body, :platform, :schedule_date, :creator_id
        ]
      ).merge({
        user_id: current_user.id
      })
    end

    def filter_params
      params.permit(:keyword)
    end
end
