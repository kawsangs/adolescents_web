# == Schema Information
#
# Table name: characteristics
#
#  id         :uuid             not null, primary key
#  code       :string
#  name_en    :string
#  name_km    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Characteristic, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
