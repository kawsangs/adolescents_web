# == Schema Information
#
# Table name: questions
#
#  id            :uuid             not null, primary key
#  code          :string
#  name          :text
#  type          :string
#  hint          :string
#  display_order :integer
#  audio         :string
#  topic_id      :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Question < ApplicationRecord
  TYPES = %w[Questions::SelectOne].freeze

  # Associations
  belongs_to :topic
  has_many   :options, dependent: :destroy

  # Mount audio
  mount_uploader :audio, AudioUploader

  # Scope
  default_scope { order(display_order: :asc) }

  validates :name, presence: true, uniqueness: { scope: :topic_id, message: "already exist" }
  validates :type, presence: true, inclusion: { in: TYPES }

  # Callback
  before_create :set_display_order
  before_create :set_field_code, if: -> { name.present? }
  before_validation :set_type

  accepts_nested_attributes_for :options, allow_destroy: true, reject_if: ->(attributes) { attributes["name"].blank? }

  private
    def set_display_order
      self.display_order ||= topic.present? && topic.questions.maximum(:display_order).to_i + 1
    end

    def set_field_code
      self.code ||= name.downcase.split(" ").map { |c| c.gsub!(/[^0-9A-Za-z]/, "") }.join("_")
    end

    def set_type
      self.type ||= self.class::TYPES[0]
    end
end
