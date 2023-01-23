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
class ImportingFacility < ApplicationRecord
  belongs_to :facility
  belongs_to :facility_batch

  accepts_nested_attributes_for :facility
end
