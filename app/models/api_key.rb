# == Schema Information
#
# Table name: api_keys
#
#  id         :uuid             not null, primary key
#  name       :string
#  api_key    :string
#  actived    :boolean          default(TRUE)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ApiKey < ApplicationRecord
  audited only: :actived

  # Association
  belongs_to :user

  # Callback
  before_create :generate_api_key

  def status
    actived? ? "actived" : "deactivated"
  end

  def self.filter(params)
    scope = all
    scope = scope.where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%") if params[:name].present?
    scope
  end

  private
    def generate_api_key
      begin
        self.api_key = SecureRandom.hex
      end while self.class.exists?(api_key:)
    end
end
