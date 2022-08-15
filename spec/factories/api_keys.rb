# == Schema Information
#
# Table name: api_keys
#
#  id         :uuid             not null, primary key
#  name       :string
#  api_key    :string
#  actived    :boolean          default(TRUE)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :api_key do
    name { FFaker::Name.name }
    user
  end
end
