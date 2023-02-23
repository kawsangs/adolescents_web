# == Schema Information
#
# Table name: tags
#
#  id             :uuid             not null, primary key
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  taggings_count :integer          default(0)
#  display_order  :integer          default(0)
#
require "rails_helper"

RSpec.describe Tag, type: :model do
  it { is_expected.to have_many(:taggings) }
  it { is_expected.to have_many(:facilities).through(:taggings) }
end
