module Samples
  module Topics
    class Option < ::Samples::Base
      def load(rows)
        rows[1..-1].each do |row|
          question = ::Question.find_by(code: row["question_code"])
          next unless question.present? && row["name"].present?

          option = question.options.find_or_initialize_by(name: row["name"])
          option.update(
            message: row["recommendation_message"],
            move_next: row["is_move_to_next_question"]
          )
        end
      end
    end
  end
end
