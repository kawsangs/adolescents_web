# == Schema Information
#
# Table name: pages
#
#  id             :uuid             not null, primary key
#  code           :string
#  name           :string
#  parent_id      :uuid
#  lft            :integer          not null
#  rgt            :integer          not null
#  depth          :integer          default(0), not null
#  children_count :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  display_name   :string
#
class Page < ApplicationRecord
  acts_as_nested_set

  has_many :visits

  before_validation :set_display_name

  def self.filter(params)
    scope = all
    scope = scope.where("LOWER(code) LIKE ? OR name LIKE ? OR display_name LIKE ?", "%#{params[:keyword].downcase}%", "%#{params[:keyword].downcase}%", "%#{params[:keyword].downcase}%") if params[:keyword].present?
    scope
  end

  private
    def set_display_name
      self.display_name ||= name
      self.name_en ||= name
      self.name_km ||= name
    end
end
