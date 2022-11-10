# == Schema Information
#
# Table name: video_batches
#
#  id          :uuid             not null, primary key
#  code        :string
#  total_count :integer          default(0)
#  valid_count :integer          default(0)
#  filename    :string
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe VideoBatch, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:videos) }
end
