class DashboardAccessibilitiesController < ApplicationController
  def show
    authorize :dashboard_accessibility, :show?

    @emails = User.where(role: :staff).pluck(:email)
  end

  def upsert
    authorize :dashboard_accessibility, :upsert?

    Setting.dashboard_accessible_emails = dashboard_accessibility_params[:dashboard_accessible_emails]
    Setting.dashboard_accessible_roles = dashboard_accessibility_params[:dashboard_accessible_roles]

    redirect_to dashboard_accessibility_url, notice: "Dashboard Accessibility was successfully updated."
  end

  private
    def dashboard_accessibility_params
      params.permit(dashboard_accessible_emails: [], dashboard_accessible_roles: [])
    end
end
