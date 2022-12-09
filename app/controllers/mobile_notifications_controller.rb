class MobileNotificationsController < ApplicationController
  def index
    @pagy, @mobile_notifications = pagy(authorize policy_scope(MobileNotification.order("updated_at DESC")))
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

  private
    def notification_params
      params.require(:mobile_notification).permit(
        :id, :title, :body, :platform
      ).merge(creator_id: current_user.id)
    end
end
