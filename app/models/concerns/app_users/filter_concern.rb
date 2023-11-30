module AppUsers::FilterConcern
  extend ActiveSupport::Concern

  included do
    # Class method
    def self.filter(params = {})
      scope = all
      scope = scope.where("registered_at BETWEEN ? AND ?", DateTime.parse(params[:start_date]).beginning_of_day, DateTime.parse(params[:end_date]).end_of_day) if params[:start_date].present? && params[:end_date].present?
      scope = scope.where(province_id: params[:province_ids]) if params[:province_ids].present?
      scope = scope.where(gender: params[:genders]) if params[:genders].present?
      scope = scope.where("age BETWEEN ? AND ?", params[:start_age], params[:end_age]) if params[:start_age].present? && params[:end_age].present?
      scope = scope.joins(:app_user_characteristics).where("app_user_characteristics.characteristic_id": params[:characteristic_ids]) if params[:characteristic_ids].present?
      scope = scope.where(platform: params[:platform]) if params[:platform].present?
      scope
    end

    def self.find_for_archive(params = {})
      user = find_or_initialize_by(params.slice(:uuid))
      user.errors.add(:uuid, I18n.t("app_user.cannot_be_blank")) if params[:uuid].blank?
      user
    end
  end
end
