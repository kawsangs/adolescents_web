class VideosController < ApplicationController
  helper_method :filter_params
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html {
        @videos = query_video
        @video_authors = VideoAuthor.order(display_order: :asc, created_at: :desc)
      }

      format.json {
        @videos = query_video

        if @videos.length > Settings.max_download_record
          flash[:alert] = t("shared.file_size_is_too_big", max_record: Settings.max_download_record)
          redirect_to videos_url
        else
          render json: @videos
        end
      }

      format.xlsx {
        @videos = query_video

        if @videos.length > Settings.max_download_record
          flash[:alert] = t("shared.file_size_is_too_big", max_record: Settings.max_download_record)
          redirect_to videos_url
        else
          render xlsx: "index", filename: "video_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.xlsx"
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

  def sort
    Video.update_order!(params[:ids])

    render json: { status: 201 }
  end

  private
    def filter_params
      params.permit(:name, :batch_code, video_author: [])
    end

    def video_params
      params.require(:video).permit(
        :name, :url, :category,
        video_author_attributes: [:name],
        video_category_attributes: [:name]
      )
    end

    def set_video
      @video = authorize Video.find(params[:id])
    end

    def query_video
      authorize Video.filter(filter_params).includes(:video_author, :video_category).order(display_order: :asc)
    end
end
