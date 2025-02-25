# == Schema Information
#
# Table name: assets
#
#  id         :uuid             not null, primary key
#  name       :string
#  platform   :integer
#  resolution :string
#  theme_id   :uuid
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Asset, type: :model do
  let(:theme) { create(:theme) }
  let(:asset) { build(:asset, theme:) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(asset).to be_valid
    end

    it "is invalid without a theme" do
      asset.theme = nil
      expect(asset).not_to be_valid
      expect(asset.errors[:theme]).to include("must exist")
    end

    context "image dimensions validation" do
      before do
        allow(asset).to receive(:image).and_return(double("image", file: double("file", file: "spec/fixtures/images/test_image.png")))
        allow(MiniMagick::Image).to receive(:open).and_return(double("image", dimensions: [375, 812]))
      end

      it "is valid when image dimensions match the expected dimensions" do
        asset.platform = "ios"
        asset.resolution = "1x"
        expect(asset).to be_valid
      end

      it "is invalid when image dimensions do not match the expected dimensions" do
        asset.platform = "ios"
        asset.resolution = "2x"
        expect(asset).not_to be_valid
        expect(asset.errors[:image]).to include("must be 750x1624px, but uploaded image is 375x812px")
      end
    end
  end

  describe "enums" do
    it "defines the correct platforms" do
      expect(Asset.platforms).to eq(MobileToken.platforms)
    end
  end

  describe "associations" do
    it "belongs to a theme" do
      expect(asset.theme).to eq(theme)
    end
  end

  describe "instance methods" do
    describe "#image_or_default" do
      it "returns the image URL if present" do
        asset.image = "example.png"
        expect(asset.image_or_default).to eq(asset.image_url)
      end

      it "returns the default image if no image is present" do
        asset.image = nil
        default_image_path = ActionController::Base.helpers.asset_path("default_image.png")
        expect(asset.image_or_default).to eq(default_image_path)
      end
    end

    describe "#image_dimension" do
      it "returns the correct image dimension key" do
        asset.platform = "ios"
        asset.resolution = "1x"
        expect(asset.image_dimension).to eq("ios_1x")
      end
    end

    describe "#css_class" do
      it "returns the correct CSS class for iOS" do
        asset.platform = "ios"
        asset.resolution = "1x"
        expect(asset.css_class).to eq("_1x")
      end

      it "returns the correct CSS class for Android" do
        asset.platform = "android"
        asset.resolution = "mdpi"
        expect(asset.css_class).to eq("mdpi")
      end
    end
  end

  describe "private methods" do
    describe "#expected_dimensions" do
      it "returns the correct dimensions for a given platform and resolution" do
        asset.platform = "ios"
        asset.resolution = "1x"
        expect(asset.send(:expected_dimensions)).to eq([375, 812])
      end

      it "returns [nil, nil] for an invalid platform and resolution" do
        asset.platform = "ios"
        asset.resolution = "invalid"
        expect(asset.send(:expected_dimensions)).to eq([nil, nil])
      end
    end

    describe "#actual_dimensions" do
      context "when image file is present" do
        before do
          # Mock the image file and its path
          allow(asset).to receive_message_chain(:image, :file, :file).and_return("spec/fixtures/images/test_image.png")
          # Mock MiniMagick to return specific dimensions
          allow(MiniMagick::Image).to receive(:open).and_return(double("image", dimensions: [375, 812]))
        end

        it "returns the actual dimensions of the image" do
          expect(asset.send(:actual_dimensions)).to eq([375, 812])
        end
      end

      context "when image file is not present" do
        before do
          # Mock the image file as nil
          allow(asset).to receive_message_chain(:image, :file, :file).and_return(nil)
        end

        it "returns [nil, nil]" do
          expect(asset.send(:actual_dimensions)).to eq([nil, nil])
        end
      end
    end
  end
end
