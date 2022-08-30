# == Schema Information
#
# Table name: working_days
#
#  id          :uuid             not null, primary key
#  facility_id :uuid
#  day         :integer          default("sunday")
#  open        :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe WorkingDay, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
