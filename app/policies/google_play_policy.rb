class GooglePlayPolicy
  attr_reader :user

  def initialize(user, _record)
    @user = user
    end

  def show?
    user.primary_admin? || user.admin?
  end
end
