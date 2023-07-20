class CategoryImportersController < ApplicationController
  include Batches::ItemableImportersConcern

  private
    def batch_type
      "CategoryBatch"
    end

    def redirect_success_url
      categories_url
    end

    def redirect_error_url
      new_category_importer_url
    end

    def itemable_attributes
      [
        :id, :code, :name, :description, :parent_id,
        :image_cache, :audio_cache, :tag_list,
        content_sources_attributes: [:id, :name, :url, :_destroy]
      ]
    end
end
