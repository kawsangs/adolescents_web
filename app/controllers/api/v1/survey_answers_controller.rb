module Api
  module V1
    class SurveyAnswersController < ApiController
      def update
        @answer = SurveyAnswer.find_by(uuid: params[:id])

        if @answer.update(answer_params)
          render json: @answer
        else
          render json: @answer.errors, status: :unprocessable_entity
        end
      end

      private
        def answer_params
          { voice: params[:voice] }
        end
    end
  end
end
