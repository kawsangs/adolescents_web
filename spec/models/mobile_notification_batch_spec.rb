# == Schema Information
#
# Table name: mobile_notification_batches
#
#  id          :bigint           not null, primary key
#  code        :string
#  total_count :integer          default(0)
#  valid_count :integer          default(0)
#  filename    :string
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe MobileNotificationBatch, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
