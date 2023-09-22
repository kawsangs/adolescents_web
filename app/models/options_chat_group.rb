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
class OptionsChatGroup < ApplicationRecord
  belongs_to :option
  belongs_to :chat_group
end
