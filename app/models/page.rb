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
#  name_en        :string
#  name_km        :string
#
class Page < ApplicationRecord
  acts_as_nested_set

  has_many :visits

  before_validation :set_name_km

  def self.filter(params)
    keyword = params[:keyword].to_s.downcase
    scope = all
    scope = scope.where("LOWER(code) LIKE ? OR name LIKE ? OR name_km LIKE ? OR name_en LIKE ?", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%") if keyword.present?
    scope
  end

  private
    def set_name_km
      self.name_en ||= name
      self.name_km ||= name
    end
end
