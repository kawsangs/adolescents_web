# == Schema Information
#
# Table name: themes
#
#  id              :uuid             not null, primary key
#  name            :string
#  status          :integer          default("draft")
#  default         :boolean          default(FALSE)
#  primary_color   :string
#  secondary_color :string
#  published_at    :datetime
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
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
    it { is_expected.to have_many(:theme_usages) }
    it { is_expected.to have_many(:app_users).through(:theme_usages) }
  end

  # Validation
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(15) }
    it { is_expected.to validate_presence_of(:primary_color) }
    it { is_expected.to validate_presence_of(:secondary_color) }
  end

  # Nested Attributes
  describe "nested attributes" do
    it "accepts nested attributes for assets" do
      expect(Theme.new).to respond_to(:assets_attributes=)
    end

    it "rejects assets with blank image" do
      theme = build(:theme, assets_attributes: [{ image: nil }])
      expect(theme.assets).to be_empty
    end

    it "allows destroying assets" do
      theme = create(:theme, :with_assets)
      expect {
        theme.update(assets_attributes: [{ id: theme.assets.first.id, _destroy: true }])
      }.to change { theme.assets.count }.by(-1)
    end
  end

  describe "scopes" do
    let!(:draft_theme) { create(:theme, status: :draft) }
    let!(:published_theme) { create(:theme, status: :published) }
    let!(:default_theme) { create(:theme, default: true) }

    describe ".published" do
      it "returns only published themes" do
        expect(Theme.published).to include(published_theme)
        expect(Theme.published).not_to include(draft_theme)
      end
    end

    describe ".defaults" do
      it "returns only default themes" do
        expect(Theme.defaults).to include(default_theme)
        expect(Theme.defaults).not_to include(draft_theme)
      end
    end

    describe ".by_name" do
      let!(:theme1) { create(:theme, name: "Dark Theme") }
      let!(:theme2) { create(:theme, name: "Light Theme") }

      it "finds themes by name case-insensitively" do
        expect(Theme.by_name("dark")).to include(theme1)
        expect(Theme.by_name("THEME")).to include(theme1, theme2)
        expect(Theme.by_name("")).not_to be_empty
        expect(Theme.by_name(nil)).not_to be_empty
      end
    end

    describe ".from_date" do
      let!(:old_theme) { create(:theme, updated_at: 2.days.ago) }
      let!(:new_theme) { create(:theme, updated_at: 1.hour.ago) }

      it "returns themes updated after timestamp" do
        timestamp = 1.day.ago.to_i

        expect(Theme.from_date(timestamp)).to include(new_theme)
        expect(Theme.from_date(timestamp)).not_to include(old_theme)
      end

      it "returns all when timestamp is 0" do
        expect(Theme.from_date(0).length).to eq(5)
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
