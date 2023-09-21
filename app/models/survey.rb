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
class Survey < ApplicationRecord
  include Surveys::NotifiableConcern

  belongs_to :topic
  belongs_to :app_user

  has_many :survey_answers, dependent: :destroy

  accepts_nested_attributes_for :survey_answers, allow_destroy: true
end
