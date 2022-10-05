module Api
  module V1
    class TopicsController < ApiController
      def index
        @topics = Topic.published.includes(:services, questions: :options)

        render json: @topics
      end
    end
  end
end
