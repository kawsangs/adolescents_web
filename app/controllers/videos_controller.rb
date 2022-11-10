class VideosController < ApplicationController
  helper_method :filter_params
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html {
        @pagy, @videos = pagy(authorize Video.filter(filter_params).order(display_order: :asc))
      }

      format.json {
        @videos = authorize Video.filter(filter_params).order(display_order: :asc)

        if @videos.length > Settings.max_download_visit_record
          flash[:alert] = t("shared.file_size_is_too_big")
          redirect_to videos_url
        else
          send_data ActiveModelSerializers::SerializableResource.new(@videos).to_json, type: :json, disposition: "attachment", filename: "videos_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.json"
        end
      }
    end
  end

  def new
    @video = Video.new
  end

  def create
    @video = authorize Video.new(video_params)

    if @video.save
      redirect_to videos_url, notice: "Video was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @video.update(video_params)
      redirect_to videos_url, notice: "Video was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @video.destroy

    redirect_to videos_url, notice: "Video was successfully destroyed."
  end

  private
    def filter_params
      params.permit(:name)
    end

    def video_params
      params.require(:video).permit(
        :name, :url, :category, :author,
        video_category_attributes: [:name]
      )
    end

    def set_video
      @video = authorize Video.find(params[:id])
    end
end
