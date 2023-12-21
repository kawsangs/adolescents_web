module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      if User.facebook_login_enabled?
        all
      else
        redirect_to new_user_session_path, alert: "Unauthorized user!"
      end
    end

    def all
      @user = User.from_omniauth(request.env["omniauth.auth"])

      if @user.present? && @user.persisted?
        @user.update_columns(sign_in_type: request.env["omniauth.auth"]["provider"], last_sign_in_at: Time.now.utc)
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: @user.sign_in_type

        sign_in_and_redirect @user, event: :authentication
      else
        redirect_to new_user_session_path, alert: I18n.t("devise.no_account")
      end
    end

    alias_method :google_oauth2, :all
  end
end
