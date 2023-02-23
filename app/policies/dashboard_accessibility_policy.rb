class DashboardAccessibilityPolicy
  attr_reader :user

  def initialize(user, _record)
    @user = user
  end

  def show?
    user.primary_admin? || user.admin?
  end

  def upsert?
    user.primary_admin? || user.admin?
  end
end
