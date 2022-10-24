module Samples
  module Topics
    class Question < ::Samples::Base
      def load(rows)
        rows[1..-1].each do |row|
          topic = ::Topic.find_by(code: row["topic_code"])
          next unless topic.present? && row["name"].present?

          question = topic.questions.find_or_initialize_by(code: row["code"])
          question.update(
            name: row["name"],
            hint: row["hint"],
            audio: get_audio(row["audio"]),
            answer: row["answer"],
            type: question_type(row["type"])
          )
        end
      end

      private
        def question_type(type)
          types[type.to_s.downcase.to_sym] || types.values.first
        end

        def types
          { selectone: "Questions::SelectOne", faq: "Questions::Faq" }
        end
    end
  end
end
