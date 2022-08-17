# == Schema Information
#
# Table name: api_keys
#
#  id         :uuid             not null, primary key
#  name       :string
#  api_key    :string
#  actived    :boolean          default(TRUE)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#
require "rails_helper"

RSpec.describe ApiKey, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
