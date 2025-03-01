# == Schema Information
#
# Table name: app_user_themes
#
#  id          :bigint           not null, primary key
#  app_user_id :uuid
#  theme_id    :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe AppUserTheme, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
