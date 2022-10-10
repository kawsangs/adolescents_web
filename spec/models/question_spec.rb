# == Schema Information
#
# Table name: questions
#
#  id            :uuid             not null, primary key
#  code          :string
#  name          :text
#  type          :string
#  hint          :string
#  display_order :integer
#  audio         :string
#  topic_id      :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "rails_helper"

RSpec.describe Question, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
