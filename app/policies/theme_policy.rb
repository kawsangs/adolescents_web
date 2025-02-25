class ThemePolicy < ApplicationPolicy
  def index?
    user.primary_admin? || user.admin?
  end

  def create?
    user.primary_admin? || user.admin?
  end

  def update?
    create? && (!record.published? || record.default?)
  end

  def edit?
    user.primary_admin? || user.admin?
  end

  def destroy?
    create? && !record.published? && !record.default?
  end

  def publish?
    update? && record.draft?
  end

  def archive?
    record.published? && !record.default?
  end

  # For view checking
  def disable_edit?
    return false if record.new_record?

    record.default? || record.published?
  end

  def enable_bg_image_edit?
    record.new_record? || record.default? || record.draft?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end
