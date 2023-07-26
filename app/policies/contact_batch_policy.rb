# frozen_string_literal: true

class ContactBatchPolicy < ApplicationPolicy
  def index?
    create?
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
    update?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
