# == Schema Information
#
# Table name: contacts
#
#  id                   :uuid             not null, primary key
#  name                 :string
#  value                :string
#  type                 :string
#  contact_directory_id :uuid
#  display_order        :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
FactoryBot.define do
  factory :contact do
    name { FFaker::Name.name }
    value { "011222333" }
    type  { "Contacts::Hotline" }
  end
end
