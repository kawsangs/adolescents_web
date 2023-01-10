class MobileNotificationsController < ApplicationController
  def index
    @pagy, @mobile_notifications = pagy(authorize policy_scope(MobileNotification.filter(filter_params).order("updated_at DESC")))
  end

  def new
    @mobile_notification = authorize MobileNotification.new
  end

  def create
    @mobile_notification = authorize MobileNotification.new(notification_params)

    if @mobile_notification.save
      redirect_to mobile_notifications_url
    else
      render :new
    end
  end

  def destroy
    @mobile_notification = authorize MobileNotification.find(params[:id])
    @mobile_notification.destroy

    redirect_to mobile_notifications_url, status: :see_other, notice: I18n.t("mobile_notification.delete_successfully", title: @mobile_notification.title)
  end

  private
    def notification_params
      params.require(:mobile_notification).permit(
        :id, :title, :body, :platform, :schedule_date
      ).merge(creator_id: current_user.id)
    end

    def filter_params
      params.permit(:title)
    end
end
