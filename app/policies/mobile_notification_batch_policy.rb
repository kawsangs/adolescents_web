class MobileNotificationBatchPolicy < ApplicationPolicy
  def index?
    user.primary_admin? || user.admin?
  end

  def show?
    index?
  end

  def create?
    user.primary_admin? || user.admin?
  end

  def update?
    create?
  end

  def destroy?
    create? && record.mobile_notifications.length.zero?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end
