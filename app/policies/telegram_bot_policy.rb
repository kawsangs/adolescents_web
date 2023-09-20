# frozen_string_literal: true

class TelegramBotPolicy < ApplicationPolicy
  def index?
    create?
  end

  def show?
    index?
  end

  def create?
    user.primary_admin?
  end

  def upsert?
    create?
  end

  def help?
    create?
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
