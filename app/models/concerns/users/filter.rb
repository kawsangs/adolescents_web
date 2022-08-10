module Users::Filter
  extend ActiveSupport::Concern

  included do
    def self.filter(params)
      scope = all
      scope = scope.where("email LIKE ?", "%#{params[:email]}%") if params[:email].present?
      scope = scope.only_deleted if params[:archived] == "true"
      scope
    end

    def self.from_omniauth(access_token)
      data = access_token.info
      User.where(email: data["email"]).first
    end
  end
end
