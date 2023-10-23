module Api
  module V1
    class SurveyFormsController < ApiController
      def show
        survey_form = Topics::SurveyForm.find_by(id: params[:id])

        render json: survey_form
      end
    end
  end
end
