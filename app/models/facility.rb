# == Schema Information
#
# Table name: facilities
#
#  id                :uuid             not null, primary key
#  name              :string
#  address           :string
#  tels              :string           default([]), is an Array
#  emails            :string           default([]), is an Array
#  websites          :string           default([]), is an Array
#  facebook_pages    :string           default([]), is an Array
#  telegram_username :string
#  description       :text
#  latitude          :float
#  longitude         :float
#  facility_batch_id :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  province_id       :string
#  district_id       :string
#  commune_id        :string
#  street            :string
#  house_number      :string
#  deleted_at        :datetime
#  logo              :string
#
class Facility < ApplicationRecord
  include Taggable

  acts_as_paranoid

  # Uploader
  mount_uploader :logo, AttachmentUploader

  # Association
  belongs_to :facility_batch, optional: true
  has_many :working_days, dependent: :destroy
  has_many :facility_services
  has_many :services, through: :facility_services

  has_many :importing_facilities
  has_many :facility_batches, through: :importing_facilities

  # Valiation
  validates :name, presence: true

  # Scope
  default_scope { order(updated_at: :desc) }

  # Nested Attribute
  accepts_nested_attributes_for :working_days, allow_destroy: true

  def services_attributes=(attributes)
    names = attributes.values.select { |a| a[:_destroy] != "1" }.pluck(:name).compact_blank

    self.service_ids = names.map { |name| Service.find_or_create_by(name:) }.collect(&:id)
  end

  def logo_or_default
    logo_url || "default_logo.png"
  end

  # Class method
  def self.filter(params = {})
    scope = all
    scope = scope.where("name LIKE ?", "%#{params[:name]}%") if params[:name].present?
    scope = scope.joins(importing_facilities: :facility_batch).where("facility_batches.code = ?", params[:batch_code]) if params[:batch_code].present?
    scope = scope.joins(taggings: :tag).where("tags.name IN (?)", params[:tag]) if params[:tag].present?
    scope
  end

  # Instant method
  def addresses
    return nil if commune.nil?

    return "ផ្ទះលេខ#{house_number} ផ្លូវ#{street} #{commune.address_km}" if I18n.locale == :km

    "##{house_number}, st. #{street}, #{commune.address_en}"
  end

  def commune
    @commune ||= Pumi::Commune.find_by_id commune_id
  end
end
