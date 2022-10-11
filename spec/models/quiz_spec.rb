# == Schema Information
#
# Table name: quizzes
#
#  id          :uuid             not null, primary key
#  app_user_id :uuid
#  topic_id    :uuid
#  quizzed_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe Quiz, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
