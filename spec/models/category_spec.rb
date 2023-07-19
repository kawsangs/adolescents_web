# == Schema Information
#
# Table name: categories
#
#  id             :uuid             not null, primary key
#  code           :string
#  name           :string
#  image          :string
#  audio          :string
#  description    :text
#  parent_id      :uuid
#  lft            :integer          not null
#  rgt            :integer          not null
#  depth          :integer          default(0), not null
#  children_count :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require "rails_helper"

RSpec.describe Category, type: :model do
  it { is_expected.to have_many(:content_sources) }
  it { is_expected.to validate_presence_of(:name) }
end
