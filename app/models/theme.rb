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
  has_many :theme_settings, dependent: :destroy
  has_many :assets, dependent: :destroy
  has_many :app_user_themes, dependent: :destroy
  has_many :app_users, through: :app_user_themes

  validates :name, presence: true, uniqueness: true
  validates :bg_color, presence: true
  validates :text_color, presence: true
  validates :button_color, presence: true
  validates :nav_bar_color, presence: true

  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: ->(attributes) { attributes["image"].blank? }

  def self.filter(params)
    name = params[:name].to_s.strip
    scope = all
    scope = scope.where("name LIKE ?", "%#{name}%") if name.present?
    scope
  end
end
