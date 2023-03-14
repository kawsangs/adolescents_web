# == Schema Information
#
# Table name: video_authors
#
#  id            :uuid             not null, primary key
#  name          :string
#  videos_count  :integer          default(0)
#  display_order :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class VideoAuthor < ApplicationRecord
  has_many :videos

  before_create :set_display_order
  before_destroy :confirm_blank_tagging

  # Scope
  default_scope { order(display_order: :asc) }

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
