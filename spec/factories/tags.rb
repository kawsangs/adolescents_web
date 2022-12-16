# == Schema Information
#
# Table name: tags
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :tag do
    name { FFaker::Name.name }
  end
end
