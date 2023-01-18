# == Schema Information
#
# Table name: mobile_notification_logs
#
#  id                     :bigint           not null, primary key
#  mobile_notification_id :integer
#  mobile_token_id        :uuid
#  failed_reason          :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
FactoryBot.define do
  factory :mobile_notification_log do
  end
end
