# == Schema Information
#
# Table name: themes
#
#  id                   :uuid             not null, primary key
#  name                 :string
#  description          :text
#  active               :boolean          default(FALSE)
#  default              :boolean          default(FALSE)
#  primary_color        :string
#  secondary_color      :string
#  primary_text_color   :string
#  secondary_text_color :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
FactoryBot.define do
  factory :theme do
    name { FFaker::Name.name }
    description { FFaker::Book.description }
    primary_color { "#000" }
    secondary_color { "#fff" }
    primary_text_color { "#000" }
    secondary_text_color { "#fff" }
  end
end
