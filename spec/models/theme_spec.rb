# == Schema Information
#
# Table name: themes
#
#  id                   :uuid             not null, primary key
#  name                 :string
#  status               :integer          default("draft")
#  default              :boolean          default(FALSE)
#  primary_color        :string
#  secondary_color      :string
#  primary_text_color   :string
#  secondary_text_color :string
#  published_at         :datetime
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
require "rails_helper"

RSpec.describe Theme, type: :model do
  # Enum
  describe "enums" do
    it { is_expected.to define_enum_for(:status).with_values(draft: 0, published: 1) }
  end

  # Soft Delete
  describe "soft delete with acts_as_paranoid" do
    let(:theme) { create(:theme) }

    it "soft deletes the theme" do
      theme
      expect { theme.destroy }.to change { Theme.count }.by(-1)
      expect(Theme.with_deleted.find(theme.id).deleted_at).to be_present
    end

    it "restores a soft-deleted theme" do
      theme.destroy
      expect { theme.restore }.to change { Theme.count }.by(1)
      expect(theme.reload.deleted_at).to be_nil
    end
  end

  # Association
  describe "associations" do
    it { is_expected.to have_many(:assets).dependent(:destroy) }
  end

  # Validation
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_presence_of(:primary_color) }
    it { is_expected.to validate_presence_of(:secondary_color) }
    it { is_expected.to validate_presence_of(:primary_text_color) }
    it { is_expected.to validate_presence_of(:secondary_text_color) }
  end

  # Scope
  describe "scopes" do
    let!(:published_theme) { create(:theme, :published) }
    let!(:draft_theme) { create(:theme) }
    let!(:default_theme) { create(:theme, :default) }
    let!(:non_default_theme) { create(:theme) }

    describe ".published" do
      it "returns only published themes" do
        expect(Theme.published).to include(published_theme)
        expect(Theme.published).not_to include(draft_theme)
      end
    end

    describe ".defaults" do
      it "returns only default themes" do
        expect(Theme.defaults).to include(default_theme)
        expect(Theme.defaults).not_to include(non_default_theme)
      end
    end
  end

  # Nested Attributes
  describe "nested attributes for assets" do
    it { should accept_nested_attributes_for(:assets).allow_destroy(true) }

    let(:theme) { build(:theme) }

    context "with invalid asset attributes (blank image)" do
      it "rejects the asset" do
        theme.attributes = { assets_attributes: [{ image: nil }] }
        expect { theme.save }.not_to change { Asset.count }
        expect(theme.assets).to be_empty
      end
    end

    context "with _destroy flag" do
      let(:theme_with_asset) { create(:theme, :with_assets) }

      it "destroys the asset" do
        expect {
          theme_with_asset.update(assets_attributes: [{ id: theme_with_asset.assets.first.id, _destroy: true }])
        }.to change { theme_with_asset.assets.count }.by(-1)
      end
    end
  end

  # Class Method
  describe ".filter" do
    let!(:theme1) { create(:theme, name: "Dark Theme", updated_at: Time.at(1640995200)) } # Jan 1, 2022
    let!(:theme2) { create(:theme, name: "Light Theme", updated_at: Time.now) }

    context "with name filter" do
      it "filters themes by name" do
        result = Theme.filter(name: "Dark")
        expect(result).to include(theme1)
        expect(result).not_to include(theme2)
      end
    end

    context "with updated_at filter" do
      it "filters themes by updated_at" do
        result = Theme.filter(updated_at: 1640995200)
        expect(result).to include(theme2)
        expect(result).not_to include(theme1)
      end
    end

    context "with both filters" do
      it "applies both name and updated_at filters" do
        create(:theme, name: "Dark Mode", updated_at: Time.now) # Matches both
        result = Theme.filter(name: "Dark", updated_at: 1640995200)
        expect(result.map(&:name)).to include("Dark Mode")
        expect(result.map(&:name)).not_to include("Dark Theme")
      end
    end

    context "with no filters" do
      it "returns all themes" do
        result = Theme.filter({})
        expect(result).to include(theme1, theme2)
      end
    end
  end

  # Instance Method
  describe "#publish" do
    let(:theme) { create(:theme) }

    it "publishes the theme" do
      expect {
        theme.publish
      }.to change { theme.reload.status }.from("draft").to("published")
       .and change { theme.published_at }.from(nil).to(be_within(1.second).of(Time.now))
    end
  end
end
