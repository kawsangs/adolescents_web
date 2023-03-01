class VideoBatchesController < ApplicationController
  before_action :set_video_batch, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @video_batches = pagy(authorize VideoBatch.filter(filter_params).order(updated_at: :desc))
  end

  def show
  end

  def new
    @video_batch = authorize VideoBatch.new
  end

  def create
    authorize VideoBatch, :create?

    if file = params[:video_batch][:file].presence
      @video_batch = Spreadsheets::VideoBatch.new(current_user).import(file)

      render :import_confirm, status: :see_other
    else

      create_video_batch
    end
  end

  def destroy
    @video_batch.destroy

    respond_to do |format|
      format.html { redirect_to video_batches_url, notice: "Video batch was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_video_batch
      @video_batch = authorize VideoBatch.find_by(code: params[:code])
    end

    def create_video_batch
      @video_batch = VideoBatch.new(video_batch_params)

      if @video_batch.save
        redirect_to video_batch_url(@video_batch.code), notice: "Video batch was successfully imported."
      else
        render :import_confirm
      end
    end

    def video_batch_params
      params.require(:video_batch).permit(
        :total_count, :valid_count, :filename,
        videos_attributes: [
          :name, :url,
          video_author_attributes: [:name],
          video_category_attributes: [:name]
        ]
      ).merge({
        user_id: current_user.id
      })
    end

    def filter_params
      params.permit(:keyword)
    end
end
