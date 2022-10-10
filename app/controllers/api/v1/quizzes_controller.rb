module Api
  module V1
    class QuizzesController < ApiController
      def create
        @quiz = Quiz.new(quiz_params)

        if @quiz.save
          render json: @quiz
        else
          render json: { errors: @quiz.errors }
        end
      end

      private
        def quiz_params
          params.require(:quiz).permit(
            :app_user_id, :topic_id, :quizzed_at,
            answers_attributes: [:question_id, :option_id, :value]
          )
        end
    end
  end
end
