class FacilitySerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :tels, :emails, :websites, :facebook_pages,
             :telegram_username, :description, :latitude, :longitude, :services,
             :updated_at

  def services
    object.services.pluck(:name)
  end
end
