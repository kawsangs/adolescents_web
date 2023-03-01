module Api
  module V1
    class TagsController < ApiController
      def index
        pagy, tags = pagy(Tag.all)

        render json: {
          pagy: pagy.vars,
          tags: ActiveModel::Serializer::CollectionSerializer.new(tags, serializer: TagSerializer)
        }
      end
    end
  end
end
