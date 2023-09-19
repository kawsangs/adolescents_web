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
#  answer        :text
#  tracking      :boolean          default(FALSE)
#  required      :boolean          default(FALSE)
#  relevant      :string
#  section_id    :uuid
#
require "rails_helper"

RSpec.describe Question, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
