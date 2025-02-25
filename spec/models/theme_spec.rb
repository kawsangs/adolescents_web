# == Schema Information
#
# Table name: themes
#
#  id          :uuid             not null, primary key
#  name        :string
#  description :text
#  active      :boolean          default(FALSE)
#  default     :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Theme, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
