class FacilitySerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :tels, :emails, :websites, :facebook_pages,
             :telegram_username, :description, :latitude, :longitude, :services,
             :updated_at

  has_many :working_days

  def services
    object.services.pluck(:name)
  end

  class WorkingDaySerializer < ActiveModel::Serializer
    attributes :day, :open

    has_many :working_hours

    class WorkingHourSerializer < ActiveModel::Serializer
      attributes :open_at, :close_at
    end
  end
end
