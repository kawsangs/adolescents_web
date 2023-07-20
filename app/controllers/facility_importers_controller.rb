class FacilityImportersController < ApplicationController
  include Batches::ItemableImportersConcern

  private
    def batch_type
      "FacilityBatch"
    end

    def redirect_success_url
      facilities_url
    end

    def redirect_error_url
      new_facility_importer_url
    end

    def itemable_attributes
      [
        :id, :name, :tag_list, :province_id, :district_id, :commune_id, :street, :house_number,
        :telegram_username, :description, :latitude, :longitude, :tag_list,
        tels: [], emails: [], websites: [], facebook_pages: [],
        working_days_attributes: [ :id, :day, :open, :_destroy, working_hours_attributes: [ :id, :open_at, :close_at ] ],
        services_attributes: [:name]
      ]
    end
end
