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
FactoryBot.define do
  factory :video do
    name { FFaker::Name.name }
    description { FFaker::Book.description }
    url { "http://#{FFaker::Youtube.url}" }
  end
end
