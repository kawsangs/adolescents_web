# == Schema Information
#
# Table name: sections
#
#  id            :uuid             not null, primary key
#  name          :string
#  topic_id      :uuid
#  display_order :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "rails_helper"

RSpec.describe Section, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
