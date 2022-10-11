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
FactoryBot.define do
  factory :quiz do
  end
end
