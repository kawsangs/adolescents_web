# == Schema Information
#
# Table name: app_user_reasons
#
#  id          :bigint           not null, primary key
#  app_user_id :uuid
#  reason_code :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :app_user_reason do
  end
end
