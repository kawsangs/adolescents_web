# == Schema Information
#
# Table name: visits
#
#  id            :uuid             not null, primary key
#  page_id       :uuid
#  visit_date    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  app_user_id   :uuid
#  pageable_id   :uuid
#  pageable_type :integer
#
class Visit < ApplicationRecord
  include Visits::Pageable

  # Association
  belongs_to :app_user

  # Callback
  after_commit :update_app_user_last_accessed, on: [:create]

  # Delegation
  delegate :platform, to: :app_user, prefix: false, allow_nil: true

  def last_visit
    self.class.where(app_user_id:, pageable_type:, pageable_id:)
              .where("visit_date >= ?", visit_date - 30.minutes)
              .first
  end

  # Class method
  def self.filter(params = {})
    scope = all
    scope = scope.where("visit_date BETWEEN ? AND ?", params[:start_date], params[:end_date]) if params[:start_date].present? && params[:end_date].present?
    scope = scope.where(page_id: params[:page_ids]) if params[:page_ids].present?
    scope = scope.joins(:app_user).where('app_users.platform': params[:platform]) if params[:platform].present?
    scope
  end

  private
    def update_app_user_last_accessed
      app_user.update_column(:last_accessed_at, visit_date)
    end
end
