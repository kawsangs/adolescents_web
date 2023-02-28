class VideoAuthor < ApplicationRecord
  has_many :videos

  before_create :set_display_order
  before_destroy :confirm_blank_tagging

  def self.filter(params)
    scope = all
    scope = scope.where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%") if params[:name].present?
    scope
  end

  private
    def confirm_blank_tagging
      if videos_count.positive?
        errors.add :tag, I18n.t("shared.cannot_delete")
        throw(:abort)
      end
    end
end
