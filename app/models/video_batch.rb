# == Schema Information
#
# Table name: video_batches
#
#  id          :uuid             not null, primary key
#  code        :string
#  total_count :integer          default(0)
#  valid_count :integer          default(0)
#  filename    :string
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class VideoBatch < ApplicationRecord
  # Association
  belongs_to :user
  has_many :videos

  # Callback
  before_create :secure_code

  # Delegation
  delegate :email, to: :user, prefix: :user

  accepts_nested_attributes_for :videos, allow_destroy: true

  def self.filter(params)
    keyword = params[:keyword].to_s.strip
    scope = all
    scope = scope.where("code LIKE ? OR filename LIKE ?", "%#{keyword}%", "%#{keyword}%") if keyword.present?
    scope
  end
end
