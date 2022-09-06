# == Schema Information
#
# Table name: app_user_characteristics
#
#  id                :uuid             not null, primary key
#  app_user_id       :uuid
#  characteristic_id :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :app_user_characteristic do
  end
end
