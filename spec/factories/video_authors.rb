# == Schema Information
#
# Table name: video_authors
#
#  id            :uuid             not null, primary key
#  name          :string
#  videos_count  :integer          default(0)
#  display_order :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :video_author do
    name { FFaker::Name.name }
  end
end
