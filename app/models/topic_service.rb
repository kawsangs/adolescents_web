# == Schema Information
#
# Table name: topic_services
#
#  id         :uuid             not null, primary key
#  topic_id   :uuid
#  service_id :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TopicService < ApplicationRecord
  belongs_to :topic
  belongs_to :service
end
