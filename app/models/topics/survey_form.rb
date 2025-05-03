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

    def deep_copy
      ActiveRecord::Base.transaction do
        # Duplicate SurveyForm
        new_survey = self.dup
        timestamp = Time.zone.now.strftime("%Y-%m-%d-%H-%M-%S")
        new_survey.name_en = "#{name_en} (#{timestamp})" if name_en.present?
        new_survey.name_km = "#{name_km} (#{timestamp})" if name_km.present?
        new_survey.version = 0
        new_survey.tag_list = tag_list
        new_survey.published_at = nil
        new_survey.save!

        # Duplicate Sections
        sections.each do |section|
          new_section = section.dup
          new_section.topic_id = new_survey.id
          new_section.save!

          # Duplicate Questions
          section.questions.each do |question|
            new_question = question.dup
            new_question.topic_id = new_survey.id
            new_question.section_id = new_section.id
            if question.audio.present? # Copy audio
              question.audio.store!
              new_question.audio = question.audio.dup
            end
            new_question.save!

            # Duplicate Options
            question.options.each do |option|
              new_option = option.dup
              new_option.question_id = new_question.id
              if option.image.present? # Copy image
                option.image.store!
                new_option.image = option.image.dup
              end
              new_option.save!
            end

            # Duplicate Criterias
            question.criterias.each do |criteria|
              new_criteria = criteria.dup
              new_criteria.question_id = new_question.id
              new_criteria.save!
            end
          end
        end

        new_survey
      end
    rescue StandardError => e
      Rails.logger.error("Failed to copy survey form: #{e.message}")
      false
    end
  end
end
