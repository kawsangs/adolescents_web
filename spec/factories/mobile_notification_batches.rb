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
FactoryBot.define do
  factory :mobile_notification_batch do
  end
end
