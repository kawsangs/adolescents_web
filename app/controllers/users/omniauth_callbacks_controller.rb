module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def all
      @user = User.from_omniauth(request.env["omniauth.auth"])

      if @user.present? && @user.persisted?
        @user.update_column(:sign_in_type, request.env["omniauth.auth"]["provider"])
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: @user.sign_in_type

        sign_in_and_redirect @user, event: :authentication
      else
        redirect_to new_user_session_path, alert: I18n.t("devise.no_account")
      end
    end

    alias_method :google_oauth2, :all
    alias_method :facebook, :all
  end
end
