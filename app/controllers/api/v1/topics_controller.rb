module Api
  module V1
    class TopicsController < ApiController
      def index
        pagy, topics = pagy(Topics::FaqForm.published.includes(questions: :options))

        render json: {
          pagy: pagy.vars,
          topics: ActiveModel::Serializer::CollectionSerializer.new(topics, serializer: FaqFormSerializer)
        }
      end
    end
  end
end
