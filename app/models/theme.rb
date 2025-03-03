# == Schema Information
#
# Table name: themes
#
#  id            :uuid             not null, primary key
#  name          :string
#  description   :text
#  active        :boolean          default(FALSE)
#  default       :boolean          default(FALSE)
#  bg_color      :string
#  text_color    :string
#  button_color  :string
#  nav_bar_color :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Theme < ApplicationRecord
  # Association
  has_many :assets, dependent: :destroy

  # Validation
  validates :name, presence: true, uniqueness: true
  validates :bg_color, presence: true
  validates :text_color, presence: true
  validates :button_color, presence: true
  validates :nav_bar_color, presence: true

  # Scope
  scope :actives, -> { where(active: true) }

  # Nested attribute
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: ->(attributes) { attributes["image"].blank? }

  # Class method
  def self.filter(params)
    name = params[:name].to_s.strip
    scope = all
    scope = scope.where("name LIKE ?", "%#{name}%") if name.present?
    scope
  end
end
