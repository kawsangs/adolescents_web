# == Schema Information
#
# Table name: topics
#
#  id           :uuid             not null, primary key
#  name_km      :string
#  version      :integer          default(0)
#  published_at :datetime
#  audio        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  code         :string
#  name_en      :string
#
require "rails_helper"

RSpec.describe Topic, type: :model do
  it { is_expected.to have_many(:questions).dependent(:destroy) }
  it { is_expected.to have_many(:topic_services) }
  it { is_expected.to have_many(:services).through(:topic_services) }

  it { is_expected.to validate_presence_of(:name_en) }
  it { is_expected.to validate_presence_of(:name_km) }
end
