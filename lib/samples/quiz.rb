module Samples
  class Quiz < Base
    def load
      ::Quiz.create(
        app_user: ::AppUser.all.sample,
        topic:,
        quizzed_at: rand(1..5).days.ago,
        answers_attributes:
      )
    end

    def answers_attributes
      topic.questions.map do |ques|
        option = ques.options.sample

        {
          question: ques,
          option:,
          value: option.name
        }
      end
    end

    def topic
      @topic ||= ::Topic.all.sample
    end
  end
end
