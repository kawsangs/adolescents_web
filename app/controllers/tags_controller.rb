class TagsController < ApplicationController
  helper_method :filter_params
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html {
        @pagy, @tags = pagy(query_tag)
      }

      format.json {
        @tags = query_tag

        if @tags.length > Settings.max_download_record
          flash[:alert] = t("shared.file_size_is_too_big", max_record: Settings.max_download_record)
          redirect_to tags_url
        else
          send_data ActiveModelSerializers::SerializableResource.new(@tags).to_json, type: :json, disposition: "attachment", filename: "tags_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.json"
        end
      }
    end
  end

  def show
  end

  def new
    @tag = authorize Tag.new
  end

  def create
    @tag = authorize Tag.new(tag_params)

    if @tag.save
      redirect_to tags_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tag.update(tag_params)
      redirect_to tags_url
    else
      render :edit
    end
  end

  def destroy
    if @tag.destroy
      redirect_to tags_url
    else
      redirect_to tags_url, alert: @tag.errors.full_messages.join(", ")
    end
  end

  private
    def filter_params
      params.permit(:name)
    end

    def tag_params
      params.require(:tag).permit(:name)
    end

    def set_tag
      @tag = authorize Tag.find(params[:id])
    end

    def query_tag
      authorize Tag.filter(filter_params).includes(:facilities).order(updated_at: :desc)
    end
end
