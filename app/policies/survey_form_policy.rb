# frozen_string_literal: true

class SurveyFormPolicy < ApplicationPolicy
  def index?
    create?
  end

  def update?
    create? && !record.published?
  end

  def create?
    user.primary_admin? || user.admin?
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
