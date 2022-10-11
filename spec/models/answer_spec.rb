# == Schema Information
#
# Table name: answers
#
#  id          :uuid             not null, primary key
#  quiz_id     :uuid
#  question_id :uuid
#  option_id   :uuid
#  value       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe Answer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
