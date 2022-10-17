# == Schema Information
#
# Table name: topics
#
#  id           :uuid             not null, primary key
#  name         :string
#  version      :integer          default(0)
#  published_at :datetime
#  audio        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  code         :string
#
require "rails_helper"

RSpec.describe Topic, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
