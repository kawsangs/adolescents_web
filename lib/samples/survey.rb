module Samples
  class Survey < Base
    def load
      ::Survey.create(
        app_user:,
        topic_id: survey_form.id,
        quizzed_at: rand(1..5).days.ago,
        survey_answers_attributes:
      )
    end

    private
      def app_user
        @app_user ||= ::AppUser.all.sample
      end

      def survey_form
        @survey_form ||= ::Topics::SurveyForm.published.sample
      end

      def survey_answers_attributes
        survey_form.questions.map do |question|
          option = question.options.sample

          {
            question:,
            option:,
            value: option.try(:name) || FFaker::Name.name
          }
        end
      end
  end
end
