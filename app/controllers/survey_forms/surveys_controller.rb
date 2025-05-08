# frozen_string_literal: true

module SurveyForms
  class SurveysController < ApplicationController
    before_action :load_survey_form, only: [:index]
    helper_method :filter_params

    MAX_DOWNLOAD_RECORD = Settings.max_download_record

    def index
      @surveys = query_surveys

      respond_to do |format|
        format.html { paginate_surveys }
        format.xlsx {
          @surveys = @surveys.includes(app_user: :characteristics)
          export_xlsx
        }
        format.csv {
          @surveys = @surveys.includes(app_user: :characteristics)
          export_csv
        }
      end
    end

    private
      def load_survey_form
        @survey_form = Topics::SurveyForm.find(params[:survey_form_id])
      end

      def filter_params
        params.permit(:start_date, :end_date, :survey_form_id)
      end

      def query_surveys
        authorize policy_scope(Survey.filter(filter_params).includes(survey_answers: :option))
      end

      def paginate_surveys
        @pagy, @surveys = pagy(@surveys)
      end

      def export_xlsx
        return handle_export_limit_exceeded if export_limit_exceeded?

        render xlsx: "index", filename: export_filename("xlsx")
      end

      def export_csv
        return handle_export_limit_exceeded if export_limit_exceeded?

        send_data view_context.build_csv_data(@survey_form, @surveys),
                  filename: export_filename("csv"),
                  type: "text/csv"
      end

      def export_limit_exceeded?
        @surveys.length > MAX_DOWNLOAD_RECORD
      end

      def handle_export_limit_exceeded
        flash[:alert] = t("shared.file_size_is_too_big", max_record: MAX_DOWNLOAD_RECORD)
        redirect_to survey_form_surveys_url(@survey_form)
      end

      def export_filename(extension)
        "#{@survey_form.name}_#{Time.current.strftime('%Y%m%d_%H%M%S')}.#{extension}"
      end
  end
end
