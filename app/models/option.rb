# == Schema Information
#
# Table name: options
#
#  id          :uuid             not null, primary key
#  question_id :uuid
#  name        :string
#  message     :text
#  move_next   :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  value       :string
#  image       :string
#
class Option < ApplicationRecord
  mount_uploader :image, ImageUploader

  # Association
  belongs_to :question
  has_many :options_chat_groups
  has_many :chat_groups, through: :options_chat_groups

  # Validation
  validates :name, presence: true, uniqueness: { scope: [:question_id] }
  before_validation :set_option_value, if: -> { name.present? }

  private
    def set_option_value
      self.value = (value.presence || name).downcase.split(" ").join("_")
    end
end
