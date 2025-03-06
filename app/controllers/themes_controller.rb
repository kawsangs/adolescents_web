class ThemesController < ApplicationController
  before_action :authorize_theme, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @themes = pagy(policy_scope(Theme.filter(filter_params)))
  end

  def show
  end

  def new
    @theme = authorize Theme.new
    load_assets
  end

  def create
    @theme = authorize Theme.new(theme_params)

    if @theme.save
      redirect_to themes_url, notice: "Theme created successfully!"
    else
      load_assets
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    load_assets
  end

  def update
    if @theme.update(theme_params)
      redirect_to themes_url, notice: "Theme updated successfully!"
    else
      load_assets
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @theme.destroy

    redirect_to themes_url
  end

  private
    def theme_params
      params.require(:theme).permit(
        :name, :description, :active, :default,
        :bg_color_primary, :bg_color_secondary, :text_color, :nav_bar_color,
        assets_attributes: [:id, :image, :resolution, :platform, :_destroy, :image_cache]
      )
    end

    def authorize_theme
      @theme = authorize Theme.find(params[:id])
    end

    def filter_params
      params.permit(:name)
    end

    def load_assets
      dimensions = [
        { platform: "ios", resolution: "1x" },
        { platform: "ios", resolution: "2x" },
        { platform: "ios", resolution: "3x" },
        { platform: "android", resolution: "mdpi" },
        { platform: "android", resolution: "hdpi" },
        { platform: "android", resolution: "xhdpi" },
        { platform: "android", resolution: "xxhdpi" }
      ]

      dimensions.each do |asset|
        @theme.assets.detect { |a| a.platform == asset[:platform] && a.resolution == asset[:resolution] } ||
        @theme.assets.find_or_initialize_by(platform: asset[:platform], resolution: asset[:resolution])
      end
    end
end
