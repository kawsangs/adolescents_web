class ThemesController < ApplicationController
  before_action :authorize_theme, only: [:edit, :update, :destroy, :publish, :archive]
  helper_method :filter_params

  def index
    respond_to do |format|
      format.html {
        @pagy, @themes = pagy(query_themes)
      }

      format.json {
        @themes = query_themes.defaults

        if @themes.length > Settings.max_download_record
          flash[:alert] = t("shared.file_size_is_too_big", max_record: Settings.max_download_record)
          redirect_to themes_url
        else
          render json: @themes
        end
      }
    end
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

  def publish
    @theme.publish

    redirect_to themes_url, notice: "Theme #{@theme.name} is published successfully."
  end

  def archive
    @theme.destroy

    redirect_to themes_url, notice: "Theme #{@theme.name} is archived successfully."
  end

  private
    def theme_params
      return default_theme_params if @theme&.default?

      params.require(:theme).permit(
        :name, :primary_color, :secondary_color, :primary_text_color, :secondary_text_color,
        assets_attributes:
      )
    end

    def default_theme_params
      params.require(:theme).permit(assets_attributes:)
    end

    def assets_attributes
      [:id, :image, :resolution, :platform, :_destroy, :image_cache]
    end

    def authorize_theme
      @theme = authorize Theme.find(params[:id])
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

    def query_themes
      authorize policy_scope(Theme.filter(filter_params).order(:created_at))
    end

    def filter_params
      params.permit(:name)
    end
end
