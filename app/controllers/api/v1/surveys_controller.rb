module Api
  module V1
    class SurveysController < ApiController
      def create
        @survey = Survey.new(survey_params)

        if @survey.save
          render json: @survey
        else
          render json: { errors: @survey.error }
        end
      end

      private
        def survey_params
          params.require(:survey).permit(
            :app_user_id, :topic_id, :quizzed_at, :mobile_notification_id,
            survey_answers_attributes: [
              :question_id, :option_id, :value
            ]
          )
        end
    end
  end
end
