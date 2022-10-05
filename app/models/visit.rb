# == Schema Information
#
# Table name: visits
#
#  id            :uuid             not null, primary key
#  page_id       :uuid
#  platform_id   :uuid
#  visit_date    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  app_user_id   :uuid
#  pageable_id   :uuid
#  pageable_type :integer
#
class Visit < ApplicationRecord
  # Association
  belongs_to :page
  belongs_to :platform
  belongs_to :app_user
  belongs_to :pageable, polymorphic: true, optional: true

  # Enum
  enum pageable_type: {
    Page: 1,
    Facility: 2,
    Video: 3
  }

  # Callback
  after_commit :update_app_user_last_accessed, on: [:create]
  before_validation :set_pageable

  # Delegation
  delegate :name, :code, to: :page, prefix: true, allow_nil: true
  delegate :name, to: :pageable, prefix: true, allow_nil: true

  # Nested attribute
  accepts_nested_attributes_for :page, reject_if: lambda { |attributes|
    attributes["code"].blank?
  }

  accepts_nested_attributes_for :platform, reject_if: lambda { |attributes|
    attributes["name"].blank?
  }

  # Instant method
  def page_attributes=(attribute)
    _page = Page.find_or_initialize_by(code: attribute[:code])
    _page.parent ||= Page.find_or_create_by(code: attribute[:parent_code]) if attribute[:parent_code].present?
    _page.update(name: attribute[:name])

    self.page = _page
    set_pageable
  end

  def set_pageable
    self.pageable ||= page
  end

  def platform_attributes=(attribute)
    self.platform = Platform.find_or_create_by(name: attribute[:name]) if attribute[:name].present?
  end

  def update_app_user_last_accessed
    app_user.update_column(:last_accessed_at, visit_date)
  end

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
    scope
  end
end
