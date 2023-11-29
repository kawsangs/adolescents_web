class ReasonImportersController < ApplicationController
  include Batches::ItemableImportersConcern

  private
    def batch_type
      "ReasonBatch"
    end

    def redirect_success_url
      reasons_url
    end

    def redirect_error_url
      new_reason_importer_url
    end

    def itemable_attributes
      [:id, :code, :name_km, :name_en]
    end
end
