module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def all
      @user = User.from_omniauth(request.env["omniauth.auth"])

      if @user.present? && @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Google"
        sign_in_and_redirect @user, event: :authentication
      else
        redirect_to new_user_session_path, alert: I18n.t("devise.no_account")
      end
    end

    alias_method :google_oauth2, :all
    alias_method :facebook, :all
  end
end
