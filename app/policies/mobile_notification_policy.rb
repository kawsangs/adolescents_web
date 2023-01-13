class MobileNotificationPolicy < ApplicationPolicy
  def index?
    user.primary_admin? || user.admin?
  end

  def create?
    index?
  end

  def destroy?
    index? && record.removeable?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end
