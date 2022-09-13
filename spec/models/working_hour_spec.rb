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
require "rails_helper"

RSpec.describe WorkingHour, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
