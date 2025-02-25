# == Schema Information
#
# Table name: theme_settings
#
#  id         :uuid             not null, primary key
#  key        :string
#  value      :string
#  theme_id   :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe ThemeSetting, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
