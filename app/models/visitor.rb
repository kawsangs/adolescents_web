# == Schema Information
#
# Table name: visitors
#
#  id          :uuid             not null, primary key
#  device_id   :string
#  page_id     :uuid
#  platform_id :uuid
#  visit_date  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Visitor < ApplicationRecord
  belongs_to :page
  belongs_to :platform

  accepts_nested_attributes_for :page, reject_if: lambda { |attributes|
    attributes["code"].blank?
  }

  accepts_nested_attributes_for :platform, reject_if: lambda { |attributes|
    attributes["name"].blank?
  }

  def page_attributes=(attribute)
    _page = Page.find_or_initialize_by(code: attribute[:code])
    _page.parent = Page.find_or_create_by(code: attribute[:parent_code]) if attribute[:parent_code].present?
    _page.update(name: attribute[:name])

    self.page = _page
  end

  def platform_attributes=(attribute)
    self.platform = Platform.find_or_create_by(name: attribute[:name]) if attribute[:name].present?
  end
end
