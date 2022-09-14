# == Schema Information
#
# Table name: facilities
#
#  id                :uuid             not null, primary key
#  name              :string
#  tels              :string           default([]), is an Array
#  address           :string
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
#
class Facility < ApplicationRecord
  # Association
  belongs_to :facility_batch, optional: true
  has_many :working_days, dependent: :destroy
  has_many :facility_services
  has_many :services, through: :facility_services

  # Valiation
  validates :name, presence: true

  # Nested Attribute
  accepts_nested_attributes_for :working_days, allow_destroy: true

  def services_attributes=(attributes)
    names = attributes.values.select { |a| a["_destroy"] != "1" }.pluck("name").compact_blank

    self.service_ids = names.map { |name| Service.find_or_create_by(name:) }.collect(&:id)
  end

  def self.filter(params = {})
    scope = all
    scope = scope.where("name LIKE ?", "%#{params[:name]}%") if params[:name].present?
    scope = scope.joins(:facility_batch).where("facility_batches.code = ?", params[:batch_code]) if params[:batch_code].present?
    scope
  end
end
