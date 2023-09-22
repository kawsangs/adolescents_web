# == Schema Information
#
# Table name: mobile_notifications
#
#  id                           :bigint           not null, primary key
#  title                        :string
#  body                         :text
#  success_count                :integer
#  failure_count                :integer
#  creator_id                   :integer
#  app_versions                 :string           default([]), is an Array
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  platform                     :integer
#  schedule_date                :datetime
#  mobile_notification_batch_id :integer
#  job_id                       :string
#  status                       :integer          default("pending")
#  detail                       :json
#  topic_id                     :uuid
#
require "rails_helper"

RSpec.describe MobileNotification, type: :model do
  it { is_expected.to belong_to(:creator).with_foreign_key(:creator_id).class_name("User") }
  it { is_expected.to have_many(:mobile_notification_logs) }

  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_most(100) }
  it { is_expected.to validate_length_of(:body).is_at_most(255) }
end
