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
class MobileNotificationLog < ApplicationRecord
  belongs_to :mobile_notification
  belongs_to :mobile_token
end
