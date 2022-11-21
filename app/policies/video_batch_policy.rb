class VideoBatchPolicy < ApplicationPolicy
  def index?
    user.primary_admin?
  end

  def show?
    index?
  end

  def create?
    user.primary_admin?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end
