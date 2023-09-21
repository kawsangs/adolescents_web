module Api
  module V1
    class QuizzesController < ApiController
      def create
        @survey = Survey.new(survey_params)

        if @survey.save
          render json: @survey
        else
          render json: { errors: @survey.errors }
        end
      end

      private
        def survey_params
          param = params.require(:quiz).permit(
            :app_user_id, :topic_id, :quizzed_at, :mobile_notification_id,
            answers_attributes: [:question_id, :option_id, :value]
          )

          param[:survey_answers_attributes] = param[:answers_attributes]
          param.delete(:answers_attributes)
          param
        end
    end
  end
end
