# == Schema Information
#
# Table name: working_hours
#
#  id             :uuid             not null, primary key
#  working_day_id :uuid
#  open_at        :integer
#  close_at       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class WorkingHour < ApplicationRecord
  # Association
  belongs_to :working_day, optional: true

  def open_24h?
    open_at == 24
  end
end
