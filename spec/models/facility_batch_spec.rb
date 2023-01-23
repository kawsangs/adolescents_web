# == Schema Information
#
# Table name: facility_batches
#
#  id             :uuid             not null, primary key
#  code           :string
#  total_count    :integer          default(0)
#  valid_count    :integer          default(0)
#  province_count :integer          default(0)
#  filename       :string
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  reference      :string
#  new_count      :integer          default(0)
#
require "rails_helper"

RSpec.describe FacilityBatch, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
