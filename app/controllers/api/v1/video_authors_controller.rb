module Api
  module V1
    class VideoAuthorsController < ApiController
      def index
        pagy, video_authors = pagy(VideoAuthor.all)

        render json: {
          pagy: pagy.vars,
          video_authors: ActiveModel::Serializer::CollectionSerializer.new(video_authors, serializer: VideoAuthorSerializer)
        }
      end
    end
  end
end
