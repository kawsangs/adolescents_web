module Api
  module V1
    class VideoTagsController < ApiController
      def index
        pagy, video_tags = pagy(Video.tag_counts)

        render json: {
          pagy: pagy.vars,
          video_tags: ActiveModel::Serializer::CollectionSerializer.new(video_tags, serializer: TagSerializer)
        }
      end
    end
  end
end
