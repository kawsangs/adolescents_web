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
#
class FacilitySerializer < ActiveModel::Serializer
  attributes :id, :name, :addresses, :province_id, :district_id, :commune_id,
             :street, :house_number, :tels, :emails, :websites, :facebook_pages,
             :telegram_username, :description, :latitude, :longitude, :services,
             :updated_at, :service_ids, :tags

  has_many :working_days

  def services
    object.services.pluck(:name)
  end

  def tags
    object.tags.pluck(:name)
  end

  def addresses
    object.addresses
  end

  class WorkingDaySerializer < ActiveModel::Serializer
    attributes :day, :open

    has_many :working_hours

    class WorkingHourSerializer < ActiveModel::Serializer
      attributes :open_at, :close_at
    end
  end
end
