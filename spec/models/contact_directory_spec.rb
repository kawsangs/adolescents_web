# == Schema Information
#
# Table name: contact_directories
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe ContactDirectory, type: :model do
  it { is_expected.to validate_presence_of(:name) }
end
