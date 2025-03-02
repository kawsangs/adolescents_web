# == Schema Information
#
# Table name: themes
#
#  id            :uuid             not null, primary key
#  name          :string
#  description   :text
#  active        :boolean          default(FALSE)
#  default       :boolean          default(FALSE)
#  bg_color      :string
#  text_color    :string
#  button_color  :string
#  nav_bar_color :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "rails_helper"

RSpec.describe Theme, type: :model do
  describe "associations" do
    it { should have_many(:assets).dependent(:destroy) }
    it { should have_many(:app_user_themes).dependent(:destroy) }
    it { should have_many(:app_users).through(:app_user_themes) }
  end

  describe "validations" do
    let(:theme) { build(:theme) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:bg_color) }
    it { should validate_presence_of(:text_color) }
    it { should validate_presence_of(:button_color) }
    it { should validate_presence_of(:nav_bar_color) }
  end

  describe "scopes" do
    let!(:active_theme) { create(:theme, active: true) }
    let!(:inactive_theme) { create(:theme, active: false) }

    it "returns active themes" do
      expect(Theme.actives).to include(active_theme)
      expect(Theme.actives).not_to include(inactive_theme)
    end
  end

  describe "nested attributes" do
    it { should accept_nested_attributes_for(:assets).allow_destroy(true) }
    
    it "rejects assets with blank image" do
      theme = Theme.new
      theme.assets_attributes = [{ image: "" }]
      expect(theme.assets).to be_empty
    end
  end

  describe '.filter' do
    let!(:theme1) { create(:theme, name: 'Dark Theme') }
    let!(:theme2) { create(:theme, name: 'Light Theme') }

    it 'filters themes by name' do
      expect(Theme.filter(name: 'Dark')).to include(theme1)
      expect(Theme.filter(name: 'Dark')).not_to include(theme2)
    end

    it 'returns all themes if no filter is applied' do
      expect(Theme.filter({})).to include(theme1, theme2)
    end
  end
end
