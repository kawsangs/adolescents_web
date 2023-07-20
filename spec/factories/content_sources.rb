# == Schema Information
#
# Table name: content_sources
#
#  id          :uuid             not null, primary key
#  name        :string
#  url         :string
#  category_id :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :content_source do
  end
end
