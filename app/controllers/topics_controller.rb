class TopicsController < ApplicationController
  helper_method :filter_params
  before_action :set_topic, only: [:show, :edit, :update, :destroy, :publish]

  def index
    respond_to do |format|
      format.html {
        @pagy, @topics = pagy(authorize policy_scope(Topic.filter(filter_params).includes(:services, :questions)))
      }

      format.json {
        @topics = authorize policy_scope(Topic.filter(filter_params).includes(:services, :questions))

        if @topics.length > Settings.max_download_record
          flash[:alert] = t("shared.file_size_is_too_big", max_record: Settings.max_download_record)
          redirect_to topics_url
        else
          send_data ActiveModelSerializers::SerializableResource.new(@topics).to_json, type: :json, disposition: "attachment", filename: "topics_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.json"
        end
      }
    end
  end

  def show
  end

  def new
    @topic = authorize Topic.new
  end

  def create
    @topic = authorize Topic.new(topic_params)

    if @topic.save
      redirect_to topics_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @topic.update(topic_params)
      redirect_to topics_url
    else
      render :edit
    end
  end

  def destroy
    @topic.destroy

    redirect_to topics_url
  end

  def publish
    @topic.update(published_at: Time.now)

    redirect_to topics_url
  end

  private
    def topic_params
      params.require(:topic).permit(:name_km, :name_en, :audio, :remove_audio,
        questions_attributes: [
          :id, :name, :type, :display_order, :answer,
          :_destroy, :hint, :audio, :remove_audio,
          options_attributes: %i[id name value move_next audio remove_audio message _destroy]
        ]
      ).merge(service_ids:)
    end

    def service_ids
      params[:topic][:service_ids].to_s.split(",")
    end

    def set_topic
      @topic = authorize Topic.find(params[:id])
    end

    def filter_params
      params.permit(:name)
    end
end
