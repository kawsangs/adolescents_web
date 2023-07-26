class ContactImportersController < ApplicationController
  include Batches::ItemableImportersConcern

  private
    def batch_type
      "ContactBatch"
    end

    def redirect_success_url
      contacts_url
    end

    def redirect_error_url
      new_contact_importer_url
    end

    def itemable_attributes
      [
        :id, :name, :value, :type,
        contact_directory_attributes: [:name]
      ]
    end
end
