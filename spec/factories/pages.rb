# == Schema Information
#
# Table name: pages
#
#  id             :uuid             not null, primary key
#  code           :string
#  name           :string
#  parent_id      :uuid
#  lft            :integer          not null
#  rgt            :integer          not null
#  depth          :integer          default(0), not null
#  children_count :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  name_en        :string
#  name_km        :string
#  visits_count   :integer          default(0)
#
FactoryBot.define do
  factory :page do
    name  { FFaker::Name.name }
    code  { "abc" }

    trait :with_parent do
      parent_id { create(:page).id }
    end
  end
end
