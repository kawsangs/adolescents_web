# == Schema Information
#
# Table name: importing_items
#
#  id            :uuid             not null, primary key
#  itemable_id   :uuid
#  itemable_type :string
#  batch_id      :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :importing_item do
  end
end
