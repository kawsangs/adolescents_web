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
class ThemeSerializer < ActiveModel::Serializer
  attributes :id, :name, :bg_color, :text_color, :button_color, :nav_bar_color,
             :updated_at, :created_at, :assets
  def assets
    assets = object.assets.group_by(&:platform)

    {
      ios: format_assets(assets["ios"]),
      android: format_assets(assets["android"])
    }
  end

  private
    def format_assets(assets)
      return {} unless assets

      sorted_assets = assets.sort_by { |asset| sort_order(asset.resolution) }
      sorted_assets.index_by(&:resolution).transform_values(&:image_url)
    end

    def sort_order(resolution)
      order = {
        "1x": 1, "2x": 2, "3x": 3,
        "mdpi": 1, "hdpi": 2, "xhdpi": 3, "xxhdpi": 4
      }
      order[resolution] || 999 # Default to a high number if resolution is unknown
    end
end
