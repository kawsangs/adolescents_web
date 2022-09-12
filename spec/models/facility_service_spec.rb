# == Schema Information
#
# Table name: facility_services
#
#  id          :uuid             not null, primary key
#  facility_id :uuid
#  service_id  :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe FacilityService, type: :model do
  it { is_expected.to belong_to(:facility) }
  it { is_expected.to belong_to(:service) }
end
