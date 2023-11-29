# == Schema Information
#
# Table name: reasons
#
#  id         :uuid             not null, primary key
#  code       :string
#  name_km    :string
#  name_en    :string
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Reason, type: :model do
  it { is_expected.to have_many(:app_user_reasons).with_primary_key(:code).with_foreign_key(:reason_code) }
  it { is_expected.to have_many(:app_users).through(:app_user_reasons) }

  it { is_expected.to validate_presence_of(:name_km) }
  it { is_expected.to validate_presence_of(:name_en) }
end
