# == Schema Information
#
# Table name: topics
#
#  id           :uuid             not null, primary key
#  name_km      :string
#  version      :integer          default(0)
#  published_at :datetime
#  audio        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  code         :string
#  name_en      :string
#  type         :string
#  description  :text
#
module Topics
  class SurveyForm < ::Topic
    # Association
    has_many :mobile_notifications, foreign_key: :topic_id
    has_many :questions, through: :sections

    # Validation
    validates_associated :sections

    def self.notification_counts
      joins(:mobile_notifications)
    end

    def self.policy_class
      SurveyFormPolicy
    end
  end
end
