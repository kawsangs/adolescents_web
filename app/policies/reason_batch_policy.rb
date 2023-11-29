# frozen_string_literal: true

class ReasonBatchPolicy < ApplicationPolicy
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
end
