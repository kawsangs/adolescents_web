# == Schema Information
#
# Table name: contact_directories
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ContactDirectory < ApplicationRecord
  # Validation
  validates :name, presence: true

  # Association
  has_many :contacts

  # Class methods
  def self.filter(params = {})
    scope = all
    scope = scope.where("name LIKE ?", "%#{params[:name].strip}%") if params[:name].present?
    scope
  end
end
