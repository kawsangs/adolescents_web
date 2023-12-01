class UserDeleteInformationsController < ActionController::Base
  layout "layouts/minimal"

  def show
    @user = AppUser.new
  end

  def destroy
    return redirect_to user_delete_information_url, notice: t("recaptcha.errors.verification_failed") unless verify_recaptcha

    @user = AppUser.find_for_archive(user_params)

    if @user.persisted? && @user.destroy_with_reason(user_params[:reason_code])
      redirect_to user_delete_information_url, notice: t("app_user.delete_info_success")
    else
      flash.now[:alert] = @user.errors.full_messages.join(", ").presence || t("app_user.invalid_info")
      render :show
    end
  end

  private
    def user_params
      params.require(:app_user).permit(:uuid, :reason_code)
    end
end
