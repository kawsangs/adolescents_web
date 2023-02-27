module Api
  module V1
    class TopicsController < ApiController
      def index
        pagy, topics = pagy(Topic.published.includes(:services, questions: :options))

        render json: { pagy: pagy.vars, topics: topics }
      end
    end
  end
end
