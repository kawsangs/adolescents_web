# frozen_string_literal: true

class ChatGroupPolicy < ApplicationPolicy
  def index?
    create?
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
