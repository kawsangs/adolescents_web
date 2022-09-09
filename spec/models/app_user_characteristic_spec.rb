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
require "rails_helper"

RSpec.describe AppUserCharacteristic, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
