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
class AppUserReason < ApplicationRecord
  belongs_to :app_user, optional: true
  belongs_to :reason, primary_key: :code, foreign_key: :reason_code
end
