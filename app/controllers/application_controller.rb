class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend
  include SortOrder

  rescue_from ::Pundit::NotAuthorizedError, with: :render_unauthorized

  before_action :authenticate_user!
  before_action :set_locale

  layout :set_layout

  private
    def set_locale
      I18n.locale = current_user.try(:locale).presence || I18n.default_locale
    end

    def set_layout
      devise_controller? ? "layouts/minimal" : "layouts/application"
    end

    def render_unauthorized
      flash[:alert] = I18n.t("shared.unauthorized_alert_message")
      redirect_to(request.referrer || root_path)
    end
end
