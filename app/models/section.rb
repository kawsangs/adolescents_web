# == Schema Information
#
# Table name: sections
#
#  id            :uuid             not null, primary key
#  name          :string
#  topic_id      :uuid
#  display_order :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Section < ApplicationRecord
  # Association
  # belongs_to :topic, inverse_of: :sections
  belongs_to :topic, inverse_of: :sections
  has_many :questions, dependent: :destroy, inverse_of: :section

  # Nested attribute
  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: ->(attributes) { attributes["name"].blank? }

  # Validation
  validates_associated :questions

  # Callback
  before_create :set_display_order
end
