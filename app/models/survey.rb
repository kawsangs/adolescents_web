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
  belongs_to :mobile_notification, optional: true

  has_many :survey_answers, dependent: :destroy

  accepts_nested_attributes_for :survey_answers, allow_destroy: true

  def survey_answers_for(question_id)
    survey_answers.find { |answer| answer.question_id == question_id }
  end

  def self.filter(params = {})
    scope = all
    scope = scope.where("created_at BETWEEN ? AND ?", DateTime.parse(params[:start_date]).beginning_of_day, DateTime.parse(params[:end_date]).end_of_day) if params[:start_date].present? && params[:end_date].present?
    scope = scope.where(topic_id: params[:survey_form_id]) if params[:survey_form_id].present?
    scope
  end
end
