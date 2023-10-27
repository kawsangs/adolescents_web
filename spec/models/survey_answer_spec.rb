# == Schema Information
#
# Table name: survey_answers
#
#  id          :uuid             not null, primary key
#  survey_id   :uuid
#  question_id :uuid
#  option_id   :uuid
#  value       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  uuid        :string
#  voice       :string
#
require "rails_helper"

RSpec.describe SurveyAnswer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
