# == Schema Information
#
# Table name: characteristics
#
#  id         :uuid             not null, primary key
#  code       :string
#  name_en    :string
#  name_km    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :characteristic do
  end
end
