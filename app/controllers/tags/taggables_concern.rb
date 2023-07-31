module Tags::TaggablesConcern
  extend ActiveSupport::Concern

  included do
    helper_method :filter_params

    def index
      respond_to do |format|
        format.html {
          @pagy, @tags = pagy(query_tags)
        }

        format.json {
          @tags = query_tags

          if @tags.length > Settings.max_download_record
            flash[:alert] = t("shared.file_size_is_too_big", max_record: Settings.max_download_record)
            redirect_to video_tags_url
          else
            render json: @tags
          end
        }
      end
    end

    private
      def filter_params
        params.permit(:name)
      end

      def query_tags
        raise NotImplementedError, "You must define #resolve in #{self.class}"
      end
  end
end
