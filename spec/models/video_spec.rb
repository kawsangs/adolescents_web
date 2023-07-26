# == Schema Information
#
# Table name: videos
#
#  id              :uuid             not null, primary key
#  name            :string
#  description     :text
#  url             :string
#  display_order   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  video_batch_id  :uuid
#  video_author_id :uuid
#
require "rails_helper"

RSpec.describe Video, type: :model do
  it { is_expected.to belong_to(:video_author).optional }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:url) }
end
