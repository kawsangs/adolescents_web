# == Schema Information
#
# Table name: options
#
#  id          :uuid             not null, primary key
#  question_id :uuid
#  name        :string
#  message     :text
#  move_next   :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  value       :string
#
require "rails_helper"

RSpec.describe Option, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
