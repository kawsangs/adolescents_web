# == Schema Information
#
# Table name: themes
#
#  id          :uuid             not null, primary key
#  name        :string
#  description :text
#  active      :boolean          default(FALSE)
#  default     :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :theme do
    
  end
end
