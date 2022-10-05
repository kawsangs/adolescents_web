# == Schema Information
#
# Table name: mobile_notifications
#
#  id            :bigint           not null, primary key
#  title         :string
#  body          :text
#  success_count :integer
#  failure_count :integer
#  creator_id    :integer
#  app_versions  :string           default([]), is an Array
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "rails_helper"

RSpec.describe MobileNotification, type: :model do
  it { is_expected.to belong_to(:creator).with_foreign_key(:creator_id).class_name("User") }

  it { is_expected.to validate_presence_of(:body) }
end
