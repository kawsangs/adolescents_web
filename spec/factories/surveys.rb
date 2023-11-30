# == Schema Information
#
# Table name: surveys
#
#  id                     :uuid             not null, primary key
#  app_user_id            :uuid
#  topic_id               :uuid
#  quizzed_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  mobile_notification_id :integer
#
FactoryBot.define do
  factory :survey do
    topic_id { create(:survey_form).id }
    quizzed_at { Time.now }
    mobile_notification
    app_user
  end
end
