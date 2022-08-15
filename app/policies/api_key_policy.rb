class ApiKeyPolicy < ApplicationPolicy
  def index?
    user.primary_admin?
  end

  def show?
    destroy?
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
    def resolve
      scope.all
    end
  end
end
