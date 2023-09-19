class FaqFormsController < ApplicationController
  helper_method :filter_params
  before_action :athorize_topic, only: [:show, :edit, :update, :destroy, :publish]

  def index
    respond_to do |format|
      format.html {
        @pagy, @topics = pagy(authorize policy_scope(Topics::FaqForm.filter(filter_params).includes(:questions)))
      }

      format.json {
        @topics = authorize policy_scope(Topics::FaqForm.filter(filter_params).includes(:questions))

        if @topics.length > Settings.max_download_record
          flash[:alert] = t("shared.file_size_is_too_big", max_record: Settings.max_download_record)
          redirect_to faq_forms_url
        else
          render json: @topics
        end
      }
    end
  end

  def show
  end

  def new
    @topic = authorize Topics::FaqForm.new
  end

  def create
    @topic = authorize Topics::FaqForm.new(topic_params)

    if @topic.save
      redirect_to faq_forms_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @topic.update(topic_params)
      redirect_to faq_forms_url
    else
      render :edit
    end
  end

  def destroy
    @topic.destroy

    redirect_to faq_forms_url
  end

  def publish
    @topic.update(published_at: Time.now)

    redirect_to faq_forms_url
  end

  private
    def topic_params
      params.require(:topics_faq_form).permit(:name_km, :name_en, :audio, :remove_audio,
        :tag_list,
        questions_attributes: [
          :id, :name, :type, :display_order, :answer,
          :_destroy, :hint, :audio, :remove_audio,
          options_attributes: %i[id name value move_next audio remove_audio message _destroy]
        ]
      )
    end

    def athorize_topic
      @topic = authorize Topics::FaqForm.find(params[:id])
    end

    def filter_params
      params.permit(:name)
    end
end
