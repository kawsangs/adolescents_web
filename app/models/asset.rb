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
class Asset < ApplicationRecord
  enum platform: MobileToken.platforms

  belongs_to :theme

  validate :validate_image_dimensions

  mount_uploader :image, AssetImageUploader

  IMAGE_DIMENSIONS = {
    'ios_1x': [375, 812],
    'ios_2x': [750, 1624],
    'ios_3x': [1125, 2436],
    'android_mdpi': [320, 480],
    'android_hdpi': [480, 800],
    'android_xhdpi': [720, 1280],
    'android_xxhdpi': [1080, 1920]
  }

  def image_or_default
    image_url || "default_image.png"
  end

  def image_dimension
    "#{platform}_#{resolution}"
  end

  def css_class
    ios? ? "_#{resolution}" : resolution
  end

  private
    def validate_image_dimensions
      return unless image.file

      required_width, required_height = expected_dimensions
      return if required_width.nil? || required_height.nil?

      actual_width, actual_height = actual_dimensions
      return if actual_width == required_width && actual_height == required_height

      errors.add(:image, "must be #{required_width}x#{required_height}px, but uploaded image is #{actual_width}x#{actual_height}px")
    end

    def expected_dimensions
      IMAGE_DIMENSIONS[image_dimension.to_sym] || [nil, nil]
    end

    def actual_dimensions
      return [nil, nil] if image.file.try(:file).nil?
      image_path = image.file.file
      MiniMagick::Image.open(image_path).dimensions
    rescue MiniMagick::Error
      [nil, nil]
    end
end
