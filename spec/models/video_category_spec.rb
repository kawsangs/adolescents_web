# == Schema Information
#
# Table name: video_categories
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe VideoCategory, type: :model do
  it { is_expected.to have_many(:videos) }
end
