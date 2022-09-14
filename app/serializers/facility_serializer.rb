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
#
class FacilitySerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :tels, :emails, :websites, :facebook_pages,
             :telegram_username, :description, :latitude, :longitude, :services,
             :updated_at

  def services
    object.services.pluck(:name)
  end
end
