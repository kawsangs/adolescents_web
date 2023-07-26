# == Schema Information
#
# Table name: contacts
#
#  id                   :uuid             not null, primary key
#  name                 :string
#  value                :string
#  type                 :string
#  contact_directory_id :uuid
#  display_order        :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Contact < ApplicationRecord
  attr_accessor :channel

  # Association
  belongs_to :contact_directory, optional: true

  # Validation
  validates :name, presence: true
  validates :value, presence: true
  validates :type, presence: true

  # Callback
  before_create :set_display_order

  # Constant
  TYPES = [
    ["Facebook", "Contacts::Facebook"],
    ["Telegram", "Contacts::Telegram"],
    ["Hotline", "Contacts::Hotline"],
    ["Website", "Contacts::Website"],
    ["Sms", "Contacts::Sms"],
    ["Messenger", "Contacts::Messenger"],
    ["Whatsapp", "Contacts::Whatsapp"]
  ]

  # Delegation
  delegate :name, to: :contact_directory, prefix: true, allow_nil: true

  # Nested attribute
  def contact_directory_attributes=(attribute)
    self.contact_directory = ContactDirectory.find_or_create_by(name: attribute[:name].downcase) if attribute[:name].present?
  end

  # Class methods
  def self.filter(params = {})
    scope = all
    scope = scope.where("name LIKE ?", "%#{params[:name]}%") if params[:name].present?
    scope = scope.joins(:contact_batch).where("contact_batches.code = ?", params[:batch_code]) if params[:batch_code].present?
    scope = scope.joins(:contact_directory).where("contact_directories.name IN (?)", params[:contact_directory]) if params[:contact_directory].present?
    scope
  end
end
