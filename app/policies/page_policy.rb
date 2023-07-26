class PagePolicy < ApplicationPolicy
  def index?
    user.primary_admin?
  end

  def show?
    index?
  end

  def create?
    false
  end

  def update?
    user.primary_admin?
  end

  def destroy?
    update? && record.visits.length.zero?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end
