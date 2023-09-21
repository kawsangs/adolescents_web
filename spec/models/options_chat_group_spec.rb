# == Schema Information
#
# Table name: options_chat_groups
#
#  id            :uuid             not null, primary key
#  option_id     :uuid
#  chat_group_id :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "rails_helper"

RSpec.describe OptionsChatGroup, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
