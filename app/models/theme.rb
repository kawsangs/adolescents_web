# == Schema Information
#
# Table name: themes
#
#  id          :uuid             not null, primary key
#  name        :string
#  description :text
#  active      :boolean          default(FALSE)
#  default     :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Theme < ApplicationRecord
  has_many :theme_settings, dependent: :destroy
  has_many :assets, dependent: :destroy
  has_many :app_user_themes, dependent: :destroy
  has_many :app_users, through: :app_user_themes

  validates :name, presence: true, uniqueness: true

  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: ->(attributes) { attributes['image'].blank? }

  def self.filter(params)
    name = params[:name].to_s.strip
    scope = all
    scope = scope.where("name LIKE ?", "%#{name}%") if name.present?
    scope
  end
end
