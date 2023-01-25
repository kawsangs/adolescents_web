# == Schema Information
#
# Table name: working_days
#
#  id          :uuid             not null, primary key
#  facility_id :uuid
#  day         :integer          default(NULL)
#  open        :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class WorkingDay < ApplicationRecord
  # Association
  belongs_to :facility, optional: true
  has_many :working_hours, dependent: :destroy

  enum day: {
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6,
    sunday: 7
  }

  # Nested Attribute
  accepts_nested_attributes_for :working_hours, allow_destroy: true, reject_if: lambda { |attributes|
    return attributes["id"].blank? && attributes["open_at"].blank? && attributes["close_at"].blank?
  }
end
