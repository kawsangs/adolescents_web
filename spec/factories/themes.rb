# == Schema Information
#
# Table name: themes
#
#  id            :uuid             not null, primary key
#  name          :string
#  description   :text
#  active        :boolean          default(FALSE)
#  default       :boolean          default(FALSE)
#  bg_color      :string
#  text_color    :string
#  button_color  :string
#  nav_bar_color :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :theme do
    name { FFaker::Name.name }
    description { FFaker::Book.description }
    bg_color { "#000" }
    text_color { "#fff" }
    button_color { "#fff" }
    nav_bar_color { "#fff" }
  end
end
