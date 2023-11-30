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
require "rails_helper"

RSpec.describe AppUserReason, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
