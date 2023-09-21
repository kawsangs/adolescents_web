module Samples
  class Survey < Base
    def load
      ::Survey.create(
        app_user:,
        topic:,
        quizzed_at: rand(1..5).days.ago,
        survey_answers_attributes:
      )
    end

    private
      def app_user
        @app_user ||= ::AppUser.all.sample
      end

      def topic
        @topic ||= ::Topics::SurveyForm.all.sample
      end

      def survey_answers_attributes
        topic.questions.map do |question|
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
