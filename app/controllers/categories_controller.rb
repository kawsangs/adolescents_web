class CategoriesController < ApplicationController
  helper_method :filter_params
  before_action :set_category, only: %i[ edit update destroy]

  def index
    respond_to do |format|
      format.html {
        @categories = authorize Category.filter(filter_params).roots.includes(:children)
      }

      format.xlsx {
        @categories = authorize Category.filter(filter_params).includes(:parent)

        if @categories.length > Settings.max_download_record
          flash[:alert] = t("shared.file_size_is_too_big", max_record: Settings.max_download_record)
          redirect_to categories_url
        else
          render xlsx: "index", filename: "categories_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.xlsx"
        end
      }

      format.json {
        @categories = authorize Category.filter(filter_params)

        render json: @categories
      }
    end
  end

  def new
    @category = authorize Category.new(parent_id: params[:parent_id])
  end

  def edit
  end

  def create
    @category = authorize Category.new(category_params)

    if @category.save
      redirect_to categories_url
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      redirect_to categories_url
    else
      render :edit
    end
  end

  def destroy
    @category.destroy

    redirect_to categories_url
  end

  private
    def set_category
      @category = authorize Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(
        :name, :description, :parent_id,
        :image, :remove_image, :audio, :remove_audio
      )
    end

    def filter_params
      params.permit(:name)
    end
end
