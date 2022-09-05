# == Schema Information
#
# Table name: app_users
#
#  id            :uuid             not null, primary key
#  gender        :string
#  age           :integer
#  province_id   :string
#  registered_at :datetime
#  device_id     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :app_user do
  end
end
