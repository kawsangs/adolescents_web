module Api
  module V1
    class TagsController < ApiController
      def index
        pagy, tags = pagy(Tag.all)

        render json: { pagy: pagy.vars, tags: tags }
      end
    end
  end
end
