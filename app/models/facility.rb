# == Schema Information
#
# Table name: facilities
#
#  id                :uuid             not null, primary key
#  name              :string
#  address           :string
#  emails            :string           default([]), is an Array
#  websites          :string           default([]), is an Array
#  facebook_pages    :string           default([]), is an Array
#  telegram_username :string
#  description       :text
#  latitude          :float
#  longitude         :float
#  facility_batch_id :uuid
#  service_id        :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Facility < ApplicationRecord
  # Association
  has_many :working_days, dependent: :destroy

  # Valiation
  validates :name, presence: true

  # Nested Attribute
  accepts_nested_attributes_for :working_days, allow_destroy: true

  def self.filter(params = {})
    scope = all
    scope = scope.where(name: params[:name]) if params[:name].present?
    scope
  end
end
