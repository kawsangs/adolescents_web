# == Schema Information
#
# Table name: services
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Service, type: :model do
  it { is_expected.to have_many(:facility_services) }
  it { is_expected.to have_many(:facilities).through(:facility_services) }

  it { is_expected.to validate_presence_of(:name) }
end
