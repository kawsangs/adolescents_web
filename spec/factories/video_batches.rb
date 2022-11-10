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
FactoryBot.define do
  factory :video_batch do
  end
end
