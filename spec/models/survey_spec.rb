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
require "rails_helper"

RSpec.describe Survey, type: :model do
  it { is_expected.to belong_to(:app_user) }
  it { is_expected.to belong_to(:topic) }
  it { is_expected.to belong_to(:mobile_notification).optional }
end
