# == Schema Information
#
# Table name: platforms
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :platform do
    name { %w(ios android web).sample }
  end
end
