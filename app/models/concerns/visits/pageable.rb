module Visits::Pageable
  extend ActiveSupport::Concern

  included do
    # Association
    belongs_to :page, counter_cache: true
    belongs_to :pageable, polymorphic: true, optional: true

    # Enum
    enum pageable_type: {
      Page: 1,
      Facility: 2,
      Video: 3,
      Topic: 4,
      Contact: 5
    }

    # Validation
    before_validation :set_pageable

    # Delegation
    delegate :name, :code, to: :page, prefix: true, allow_nil: true
    delegate :name, to: :pageable, prefix: true, allow_nil: true

    # Nested attribute
    accepts_nested_attributes_for :page, reject_if: lambda { |attributes|
      attributes["code"].blank?
    }

    # Instant method
    def page_attributes=(attribute)
      _page = Page.find_or_initialize_by(code: attribute[:code])
      _page.parent ||= Page.find_or_create_by(code: attribute[:parent_code]) if attribute[:parent_code].present?
      _page.update(name: attribute[:name])

      self.page = _page
      set_pageable
    end

    def page_detail
      return if pageable_type == "Page"

      pageable_name
    end

    private
      def set_pageable
        self.pageable ||= page
      end
  end
end
