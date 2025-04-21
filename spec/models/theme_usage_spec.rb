# == Schema Information
#
# Table name: theme_usages
#
#  id          :uuid             not null, primary key
#  app_user_id :uuid             not null
#  theme_id    :uuid             not null
#  applied_at  :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe ThemeUsage, type: :model do
  # Association tests
  describe "associations" do
    it { should belong_to(:app_user) }
    it { should belong_to(:theme) }
  end

  # Validation tests
  describe "validations" do
    it { should validate_presence_of(:applied_at) }
  end

  # Factory setup and basic tests
  describe "with valid attributes" do
    let(:theme_usage) { create(:theme_usage) }

    it "is valid with valid attributes" do
      expect(theme_usage).to be_valid
    end
  end

  describe "with invalid attributes" do
    it "is invalid without applied_at" do
      theme_usage = build(:theme_usage, applied_at: nil)
      expect(theme_usage).not_to be_valid
      expect(theme_usage.errors[:applied_at]).to include("can't be blank")
    end
  end
end
