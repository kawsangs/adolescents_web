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
class FacilityService < ApplicationRecord
  belongs_to :facility
  belongs_to :service
end
