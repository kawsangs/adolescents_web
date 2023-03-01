class GrafanaPolicy
  attr_reader :user

  def initialize(user, _record)
    @user = user
    end

  def show?
    ENV["GF_DASHBOARD_URL"].present? &&
    (user.primary_admin? ||
      user.admin? ||
      Setting.dashboard_accessible_roles.include?(user.role) ||
      Setting.dashboard_accessible_emails.include?(user.email)
    )
  end
end
