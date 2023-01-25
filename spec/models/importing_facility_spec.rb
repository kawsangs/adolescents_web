# == Schema Information
#
# Table name: importing_facilities
#
#  id                :bigint           not null, primary key
#  facility_id       :uuid
#  facility_batch_id :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require "rails_helper"

RSpec.describe ImportingFacility, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
