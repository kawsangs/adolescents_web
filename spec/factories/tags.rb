# == Schema Information
#
# Table name: tags
#
#  id             :uuid             not null, primary key
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  taggings_count :integer          default(0)
#  display_order  :integer          default(0)
#
FactoryBot.define do
  factory :tag do
    name { FFaker::Name.name }
  end
end
