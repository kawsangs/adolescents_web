class TopicPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.primary_admin? || user.admin?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def publish?
    create?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end