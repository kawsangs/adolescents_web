module ThemesHelper
  def asset_image_title(asset)
    I18n.t("theme.image_title_#{asset.image_dimension}")
  end

  def ios_assets(assets)
    assets.select { |asset| asset.platform == "ios" }
          .sort_by! { |asset| %w(1x 2x 3x).index(asset.resolution) || 0 }
  end

  def android_assets(assets)
    assets.select { |asset| asset.platform == "android" }
          .sort_by! { |asset| %w(mdpi hdpi xhdpi xxhdpi).index(asset.resolution) || 0 }
  end
end
