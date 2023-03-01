require "rails_helper"

RSpec.describe VideoAuthor, type: :model do
  it { is_expected.to have_many(:videos) }

  it "has a videos counter cache" do
    video_author = create(:video_author)

    expect {
      create(:video, video_author:)
    }.to change { VideoAuthor.last.videos_count }.by(1)
  end
end
