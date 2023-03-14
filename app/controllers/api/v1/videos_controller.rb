module Api
  module V1
    class VideosController < ApiController
      def index
        pagy, videos = pagy(Video.includes(:video_author, :video_category))

        render json: {
          pagy: pagy.vars,
          videos: ActiveModel::Serializer::CollectionSerializer.new(videos, serializer: VideoSerializer)
        }
      end
    end
  end
end
