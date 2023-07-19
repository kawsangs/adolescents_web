# == Schema Information
#
# Table name: taggings
#
#  id            :bigint           not null, primary key
#  tag_id        :uuid
#  facility_id   :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  taggable_id   :uuid
#  taggable_type :string
#
require "rails_helper"

RSpec.describe Tagging, type: :model do
  it { is_expected.to belong_to(:tag) }
  it { is_expected.to belong_to(:taggable) }
end
