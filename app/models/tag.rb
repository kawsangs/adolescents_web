# == Schema Information
#
# Table name: tags
#
#  id             :uuid             not null, primary key
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  taggings_count :integer          default(0)
#  display_order  :integer          default(0)
#
class Tag < ApplicationRecord
  has_many :taggings
  has_many :facilities, through: :taggings

  before_create :set_display_order
  before_destroy :confirm_blank_tagging

  def self.filter(params)
    scope = all
    scope = scope.where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%") if params[:name].present?
    scope
  end

  private
    def confirm_blank_tagging
      if taggings.present?
        errors.add :tag, I18n.t("shared.cannot_delete")
        throw(:abort)
      end
    end
end
