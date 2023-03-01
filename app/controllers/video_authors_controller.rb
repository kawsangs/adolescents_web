class VideoAuthorsController < ApplicationController
  helper_method :filter_params
  before_action :set_video_author, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html {
        @video_authors = query_video_authors
      }

      format.json {
        @video_authors = query_video_authors

        if @video_authors.length > Settings.max_download_record
          flash[:alert] = t("shared.file_size_is_too_big", max_record: Settings.max_download_record)
          redirect_to video_authors_url
        else
          send_data ActiveModelSerializers::SerializableResource.new(@video_authors).to_json, type: :json, disposition: "attachment", filename: "video_authors_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.json"
        end
      }
    end
  end

  def show
  end

  def new
    @video_author = authorize VideoAuthor.new
  end

  def create
    @video_author = authorize VideoAuthor.new(video_author_params)

    if @video_author.save
      redirect_to video_authors_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @video_author.update(video_author_params)
      redirect_to video_authors_url
    else
      render :edit
    end
  end

  def destroy
    if @video_author.destroy
      redirect_to video_authors_url
    else
      redirect_to video_authors_url, alert: @video_author.errors.full_messages.join(", ")
    end
  end

  def sort
    authorize VideoAuthor

    VideoAuthor.update_order!(params[:ids])

    render json: { status: 201 }
  end

  private
    def filter_params
      params.permit(:name)
    end

    def video_author_params
      params.require(:video_author).permit(:name)
    end

    def set_video_author
      @video_author = authorize VideoAuthor.find(params[:id])
    end

    def query_video_authors
      authorize VideoAuthor.filter(filter_params).order(display_order: :asc, created_at: :desc)
    end
end
