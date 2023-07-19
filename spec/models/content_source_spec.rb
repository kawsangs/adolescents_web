# == Schema Information
#
# Table name: content_sources
#
#  id          :uuid             not null, primary key
#  name        :string
#  url         :string
#  category_id :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe ContentSource, type: :model do
  it { is_expected.to belong_to(:category) }
end
