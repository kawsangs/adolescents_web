class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @pages = pagy(authorize Page.filter(filter_params).order(updated_at: :desc).includes(:children))
  end

  def show
  end

  def new
    @page = authorize Page.new
  end

  def create
    @page = authorize Page.new(page_params)

    if @page.save
      redirect_to pages_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @page.update(page_params)
      redirect_to pages_url
    else
      render :edit
    end
  end

  def destroy
    @page.destroy

    redirect_to pages_url
  end

  private
    def filter_params
      params.permit(:keyword)
    end

    def page_params
      params.require(:page).permit(:code, :name, :display_name, :parent_id)
    end

    def set_page
      @page = authorize Page.find(params[:id])
    end
end
