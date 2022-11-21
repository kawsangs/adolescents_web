class UserPolicy < ApplicationPolicy
  def index?
    user.primary_admin? || user.admin?
  end

  def show?
    user.primary_admin? || user.admin?
  end

  def create?
    user.primary_admin? || user.admin?
  end

  def update?
    create?
  end

  def archive?
    return false if record.id == user.id

    create? && !record.primary_admin?
  end

  def restore?
    record.deleted?
  end

  def destroy?
    archive? && record.deleted?
  end

  def unlock_access?
    update?
  end

  def resend_confirmation?
    update?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      return scope.all if user.primary_admin?

      scope.where.not(role: :primary_admin)
    end
  end
end
