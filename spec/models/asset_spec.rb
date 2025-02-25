# == Schema Information
#
# Table name: assets
#
#  id         :uuid             not null, primary key
#  name       :string
#  platform   :integer
#  resolution :string
#  theme_id   :uuid
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Asset, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
