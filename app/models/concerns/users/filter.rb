module Users::Filter
  extend ActiveSupport::Concern

  included do
    def self.filter(params)
      scope = all
      scope = scope.where("email LIKE ?", "%#{params[:email]}%") if params[:email].present?
      scope = scope.only_deleted if params[:archived] == "true"
      scope
    end
  end
end
